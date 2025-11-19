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

  /// Get the queue data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Returns an empty list if no packages are queued.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getQueueData(Server server);

  /// Get the collector data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Returns an empty list if no packages are in the collector.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getCollectorData(Server server);

  /// Get the queue packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Does not include file details - use getPackageData for full details.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getQueue(Server server);

  /// Get the collector packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Does not include file details - use getPackageData for full details.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getCollector(Server server);

  /// Get complete information about a package, including files
  ///
  /// Returns PackageData with complete information including all files.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<PackageData> getPackageData(Server server, int packageId);

  /// Deletes packages by their IDs
  ///
  /// Throws: String with user-friendly error message on failure
  Future<void> deletePackages(Server server, List<int> packageIds);
}
