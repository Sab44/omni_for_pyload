import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

/// Interface for PyLoad API interactions
abstract class IPyLoadApiRepository {
  /// Test the connection to a PyLoad server and authenticate
  ///
  /// This method verifies that the server is reachable and the credentials are valid
  /// by attempting to get the server status.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<void> testServerConnection(Server server);

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<DownloadInfo>> getDownloadStatus(Server server);
}
