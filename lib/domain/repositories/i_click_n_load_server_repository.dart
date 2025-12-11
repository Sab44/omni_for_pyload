import 'package:omni_for_pyload/domain/models/clicknload_server.dart';

/// Interface for ClickNLoadServer storage and retrieval
/// Maintains a 1:1 mapping between Server (identified by IP:port) and ClickNLoadServer
abstract class IClickNLoadServerRepository {
  /// Initialize the repository (setup Hive, register adapters, etc.)
  Future<void> initialize();

  /// Get a ClickNLoadServer by its associated server identifier (IP:port)
  Future<ClickNLoadServer?> getClickNLoadServerByServerIdentifier(String serverIdentifier);

  /// Add or update a ClickNLoadServer
  Future<void> addClickNLoadServer(ClickNLoadServer server);

  /// Check if a ClickNLoadServer exists for a given server identifier
  Future<bool> clickNLoadServerExists(String serverIdentifier);

  /// Remove a ClickNLoadServer by server identifier
  Future<void> removeClickNLoadServer(String serverIdentifier);
}
