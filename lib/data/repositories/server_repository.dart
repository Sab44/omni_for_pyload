import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';

class ServerRepository implements IServerRepository {
  static const String _boxName = 'servers';
  static const String _securePrefix = 'server_credentials:';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ServerAdapter());
    }
    // Migrate any existing credentials stored in Hive into secure storage
    // This migration should be deleted eventually
    try {
      final box = await _getBox();
      for (final key in box.keys) {
        final server = box.get(key);
        if (server != null &&
            (server.username.isNotEmpty || server.password.isNotEmpty)) {
          await _writeCredentials(
            server.ip,
            server.port,
            server.username,
            server.password,
          );
          final safeServer = server.copyWith(username: '', password: '');
          await box.put(key, safeServer);
        }
      }
    } catch (_) {}
  }

  Future<Box<Server>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Server>(_boxName);
    }
    return await Hive.openBox<Server>(_boxName);
  }

  /// Get all servers from local storage
  @override
  Future<List<Server>> getAllServers() async {
    final box = await _getBox();
    final servers = box.values.toList();

    // Reattach credentials from secure storage
    for (var i = 0; i < servers.length; i++) {
      final server = servers[i];
      final cred = await _readCredentials(server.ip, server.port);
      if (cred != null) {
        servers[i] = server.copyWith(
          username: cred['username'],
          password: cred['password'],
        );
      }
    }

    return servers;
  }

  /// Add a new server
  @override
  Future<void> addServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    // Store credentials in secure storage and write server without credentials to Hive
    await _writeCredentials(
      server.ip,
      server.port,
      server.username,
      server.password,
    );
    final safeServer = server.copyWith(username: '', password: '');
    await box.put(key, safeServer);
  }

  /// Check if a server with the same IP and port already exists
  @override
  Future<bool> serverExists(String ip, int port) async {
    final servers = await getAllServers();
    return servers.any((server) => server.ip == ip && server.port == port);
  }

  /// Remove a server by IP and port
  @override
  Future<void> removeServer(String ip, int port) async {
    final box = await _getBox();
    final key = '${ip}:${port}';
    // Remove credentials stored for this server
    try {
      await _deleteCredentials(ip, port);
    } catch (_) {}

    await box.delete(key);
  }

  /// Update an existing server
  @override
  Future<void> updateServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    // Update credentials in secure storage and update Hive with safe server
    await _writeCredentials(
      server.ip,
      server.port,
      server.username,
      server.password,
    );
    final safeServer = server.copyWith(username: '', password: '');
    await box.put(key, safeServer);
  }

  /// Clear all servers
  @override
  Future<void> clearAllServers() async {
    final box = await _getBox();
    // Delete credentials for all stored servers
    for (final server in box.values) {
      await _deleteCredentials(server.ip, server.port);
    }
    await box.clear();
  }

  /// Secure storage helpers
  String _secureKey(String ip, int port) => '$_securePrefix$ip:$port';

  Future<void> _writeCredentials(
    String ip,
    int port,
    String username,
    String password,
  ) async {
    final key = _secureKey(ip, port);
    final map = {'username': username, 'password': password};
    await _secureStorage.write(key: key, value: jsonEncode(map));
  }

  Future<Map<String, String>?> _readCredentials(String ip, int port) async {
    final key = _secureKey(ip, port);
    final val = await _secureStorage.read(key: key);
    if (val == null) return null;
    try {
      final decoded = jsonDecode(val) as Map<String, dynamic>;
      return {
        'username': decoded['username'] as String? ?? '',
        'password': decoded['password'] as String? ?? '',
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> _deleteCredentials(String ip, int port) async {
    final key = _secureKey(ip, port);
    await _secureStorage.delete(key: key);
  }
}
