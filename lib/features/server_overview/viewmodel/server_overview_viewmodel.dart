import 'package:flutter/material.dart';
import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class ServerOverviewViewModel extends ChangeNotifier {
  List<Server> _servers = [];

  List<Server> get servers => _servers;

  /// Load all servers from storage
  Future<void> loadServers() async {
    _servers = await ServerRepository.getAllServers();
    notifyListeners();
  }

  /// Remove a server by its IP and port key
  Future<void> removeServer(Server server) async {
    final key = '${server.ip}:${server.port}';
    await ServerRepository.removeServer(key);
    _servers.removeWhere((s) => s.ip == server.ip && s.port == server.port);
    notifyListeners();
  }

  /// Refresh the server list from storage
  Future<void> refresh() async {
    await loadServers();
  }
}
