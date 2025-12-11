import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/repositories/i_click_n_load_server_repository.dart';

class ClickNLoadServerRepository implements IClickNLoadServerRepository {
  static const String _boxName = 'clicknload_servers';

  @override
  Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ClickNLoadServerAdapter());
    }
  }

  Future<Box<ClickNLoadServer>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ClickNLoadServer>(_boxName);
    }
    return await Hive.openBox<ClickNLoadServer>(_boxName);
  }

  /// Get a ClickNLoadServer by its associated server identifier (IP:port)
  @override
  Future<ClickNLoadServer?> getClickNLoadServerByServerIdentifier(String serverIdentifier) async {
    final box = await _getBox();
    return box.get(serverIdentifier);
  }

  /// Add or update a ClickNLoadServer
  /// Uses the serverIdentifier as the key to maintain 1:1 mapping
  @override
  Future<void> addClickNLoadServer(ClickNLoadServer server) async {
    final box = await _getBox();
    await box.put(server.serverIdentifier, server);
  }

  /// Check if a ClickNLoadServer exists for a given server identifier
  @override
  Future<bool> clickNLoadServerExists(String serverIdentifier) async {
    final box = await _getBox();
    return box.containsKey(serverIdentifier);
  }

  /// Remove a ClickNLoadServer by server identifier
  @override
  Future<void> removeClickNLoadServer(String serverIdentifier) async {
    final box = await _getBox();
    await box.delete(serverIdentifier);
  }
}
