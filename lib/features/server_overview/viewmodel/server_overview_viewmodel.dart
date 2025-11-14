import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class ServerOverviewViewModel extends ChangeNotifier {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  List<Server> _servers = [];

  ServerOverviewViewModel({
    required IServerRepository serverRepository,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _serverRepository = serverRepository,
       _pyLoadApiRepository = pyLoadApiRepository;

  List<Server> get servers => _servers;

  /// Load all servers from storage
  Future<void> loadServers() async {
    _servers = await _serverRepository.getAllServers();
    notifyListeners();
  }

  /// Remove a server by its IP and port key
  Future<void> removeServer(Server server) async {
    final key = '${server.ip}:${server.port}';
    await _serverRepository.removeServer(key);
    _servers.removeWhere((s) => s.ip == server.ip && s.port == server.port);
    notifyListeners();
  }

  /// Refresh the server list from storage
  Future<void> refresh() async {
    await loadServers();
  }

  /// Fetch online status for a given server.
  Future<String> fetchOnlineStatus(Server server) async {
    try {
      await _pyLoadApiRepository.testServerConnection(server);
      return 'online';
    } catch (e) {
      return 'offline';
    }
  }
}
