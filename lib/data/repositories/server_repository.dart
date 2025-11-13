import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';

class ServerRepository implements IServerRepository {
  static const String _boxName = 'servers';

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ServerAdapter());
    }
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
    return box.values.toList();
  }

  /// Add a new server
  @override
  Future<void> addServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    await box.put(key, server);
  }

  /// Check if a server with the same IP and port already exists
  @override
  Future<bool> serverExists(String ip, int port) async {
    final servers = await getAllServers();
    return servers.any((server) => server.ip == ip && server.port == port);
  }

  /// Remove a server by key
  @override
  Future<void> removeServer(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Clear all servers
  @override
  Future<void> clearAllServers() async {
    final box = await _getBox();
    await box.clear();
  }
}
