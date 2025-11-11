import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class ServerRepository {
  static const String _boxName = 'servers';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ServerAdapter());
    }
  }

  static Future<Box<Server>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Server>(_boxName);
    }
    return await Hive.openBox<Server>(_boxName);
  }

  /// Get all servers from local storage
  static Future<List<Server>> getAllServers() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// Add a new server
  static Future<void> addServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    await box.put(key, server);
  }

  /// Check if a server with the same IP and port already exists
  static Future<bool> serverExists(String ip, int port) async {
    final servers = await getAllServers();
    return servers.any((server) => server.ip == ip && server.port == port);
  }

  /// Remove a server by key
  static Future<void> removeServer(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Clear all servers
  static Future<void> clearAllServers() async {
    final box = await _getBox();
    await box.clear();
  }
}
