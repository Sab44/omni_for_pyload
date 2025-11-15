import 'dart:async';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class PyLoadApiRepository implements IPyLoadApiRepository {
  static const Duration _connectionTimeout = Duration(seconds: 5);

  ApiClient? _cachedApiClient;
  PyLoadRESTApi? _cachedApi;

  /// Configures and returns a PyLoadRESTApi instance with proper authentication
  ///
  /// Uses caching for the same server configuration.
  /// Creates a new instance if the server configuration changes.
  ///
  /// Parameters:
  /// - [server]: The server configuration with IP, port, username, and password
  ///
  /// Returns a configured PyLoadRESTApi instance
  PyLoadRESTApi _configureApi(Server server) {
    final basePath = '${server.protocol}://${server.ip}:${server.port}';

    // Return cached API if the server hasn't changed
    if (_cachedApiClient?.basePath == basePath && _cachedApi != null) {
      return _cachedApi!;
    }

    final basicAuth = HttpBasicAuth();
    basicAuth.username = server.username;
    basicAuth.password = server.password;

    // Create API client with the server configuration and authentication
    _cachedApiClient = ApiClient(basePath: basePath, authentication: basicAuth);

    // Create API instance with the configured client
    _cachedApi = PyLoadRESTApi(_cachedApiClient);

    return _cachedApi!;
  }

  /// Executes a network request with timeout and error handling
  ///
  /// Wraps any Future-returning API call with:
  /// - Timeout handling (5 seconds default)
  /// - API exception handling with user-friendly messages
  /// - Generic error handling
  ///
  /// Parameters:
  /// - [request]: A Future that represents the API call
  /// - [timeout]: Optional custom timeout duration
  ///
  /// Throws:
  /// - String with user-friendly error message on failure
  Future<T> executeNetworkRequest<T>(
    Future<T> Function() request, {
    Duration timeout = _connectionTimeout,
  }) async {
    try {
      return await request().timeout(
        timeout,
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );
    } on TimeoutException {
      throw 'Server connection timed out.';
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

  /// Test the connection to a PyLoad server and authenticate
  ///
  /// This method verifies that the server is reachable and the credentials are valid
  /// by attempting to get the server status.
  @override
  Future<void> testServerConnection(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiStatusServerGet());
  }

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  @override
  Future<List<DownloadInfo>> getDownloadStatus(Server server) async {
    final api = _configureApi(server);
    final downloadInfoList = await executeNetworkRequest(
      () => api.apiStatusDownloadsGet(),
    );
    return downloadInfoList ?? [];
  }

  /// Get the queue data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Returns an empty list if no packages are queued.
  @override
  Future<List<PackageData>> getQueueData(Server server) async {
    final api = _configureApi(server);
    final queueDataList = await executeNetworkRequest(
      () => api.apiGetQueueDataGet(),
    );
    return queueDataList ?? [];
  }
}
