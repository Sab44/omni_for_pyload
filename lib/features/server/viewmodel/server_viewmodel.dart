import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class ServerViewModel extends ChangeNotifier {
  final IPyLoadApiRepository _pyLoadApiRepository;
  final Server server;
  int _selectedTabIndex = 0;
  List<DownloadInfo> _downloads = [];
  List<PackageData> _queueData = [];
  List<PackageData> _collectorData = [];
  final Set<int> _selectedPackageIds = {};
  String? _error;
  Timer? _pollTimer;

  ServerViewModel({
    required this.server,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _pyLoadApiRepository = pyLoadApiRepository;

  int get selectedTabIndex => _selectedTabIndex;
  List<DownloadInfo> get downloads => _downloads;
  List<PackageData> get queueData => _queueData;
  List<PackageData> get collectorData => _collectorData;
  Set<int> get selectedPackageIds => _selectedPackageIds;
  bool get isSelectionMode => _selectedPackageIds.isNotEmpty;
  String? get error => _error;

  void setSelectedTab(int index) {
    if (_selectedTabIndex != index) {
      clearSelection();
    }
    _selectedTabIndex = index;
    if (index == 0) {
      // Start polling when Overview tab is selected
      _startPollingDownloads();
    } else if (index == 1) {
      // Start polling when Queue tab is selected
      _startPollingQueue();
    } else if (index == 2) {
      // Start polling when Collector tab is selected
      _startPollingCollector();
    } else {
      // Stop polling when another tab is selected
      _stopPolling();
    }
    notifyListeners();
  }

  /// Fetch the current download status from the server
  Future<void> _fetchDownloadStatus() async {
    try {
      _error = null;
      notifyListeners();

      _downloads = await _pyLoadApiRepository.getDownloadStatus(server);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Fetch the queue data from the server
  Future<void> _fetchQueueData() async {
    try {
      _error = null;
      notifyListeners();

      List<PackageData> queue = await _pyLoadApiRepository.getQueue(server);
      _queueData = queue.reversed.toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Fetch the collector data from the server
  Future<void> _fetchCollectorData() async {
    try {
      _error = null;
      notifyListeners();

      List<PackageData> collector = await _pyLoadApiRepository.getCollector(
        server,
      );
      _collectorData = collector.reversed.toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Start polling downloads every second
  void _startPollingDownloads() {
    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchDownloadStatus();

    // Then poll every second
    _pollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _fetchDownloadStatus(),
    );
  }

  /// Start polling queue data every second
  void _startPollingQueue() {
    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchQueueData();

    // Then poll every 10 seconds
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchQueueData(),
    );
  }

  /// Start polling collector data every 10 seconds
  void _startPollingCollector() {
    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchCollectorData();

    // Then poll every 10 seconds
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchCollectorData(),
    );
  }

  /// Stop polling downloads
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void toggleSelection(int packageId) {
    if (_selectedPackageIds.contains(packageId)) {
      _selectedPackageIds.remove(packageId);
    } else {
      _selectedPackageIds.add(packageId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedPackageIds.clear();
    notifyListeners();
  }

  void deleteSelectedPackages() {
    // TODO: Implement delete
    clearSelection();
  }

  void restartSelectedPackages() {
    // TODO: Implement restart
    clearSelection();
  }

  void moveSelectedPackages() {
    // TODO: Implement move
    clearSelection();
  }

  void extractSelectedPackages() {
    // TODO: Implement extract
    clearSelection();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
