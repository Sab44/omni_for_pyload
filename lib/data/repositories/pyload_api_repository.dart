import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class PyLoadApiRepository {
  /// Test the connection to a PyLoad server and authenticate
  ///
  /// This method verifies that the server is reachable and the credentials are valid
  /// by attempting to get the server status.
  ///
  /// Throws an exception if:
  /// - The server is unreachable
  /// - Authentication fails
  /// - Any other network/API error occurs
  static Future<void> testServerConnection(Server server) async {
    final protocol = server.isHttps ? 'https' : 'http';
    final basePath = '$protocol://${server.ip}:${server.port}';

    // Set up HTTP Basic Auth
    final basicAuth = HttpBasicAuth();
    basicAuth.username = server.username;
    basicAuth.password = server.password;

    // Create API client with the server configuration and authentication
    final apiClient = ApiClient(basePath: basePath, authentication: basicAuth);

    // Create API instance with the configured client
    final api = PyLoadRESTApi(apiClient);

    try {
      // Attempt to get server status to verify connection and auth
      await api.apiStatusServerGet();
      // If we get here without throwing, the connection is successful
    } catch (e) {
      // Re-throw with a user-friendly message
      if (e is ApiException) {
        if (e.code == 401) {
          throw 'Authentication failed. Please check your username and password.';
        } else if (e.code >= 500) {
          throw 'Server error: ${e.message}';
        } else {
          throw 'Server connection failed: ${e.message}';
        }
      } else {
        throw 'Failed to connect to server: $e';
      }
    }
  }
}
