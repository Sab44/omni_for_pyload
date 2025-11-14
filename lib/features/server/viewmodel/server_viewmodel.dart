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
  bool _isLoading = false;
  String? _error;
  Timer? _pollTimer;

  ServerViewModel({
    required this.server,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _pyLoadApiRepository = pyLoadApiRepository;

  int get selectedTabIndex => _selectedTabIndex;
  List<DownloadInfo> get downloads => _downloads;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    if (index == 0) {
      // Start polling when Overview tab is selected
      _startPolling();
    } else {
      // Stop polling when another tab is selected
      _stopPolling();
    }
    notifyListeners();
  }

  /// Fetch the current download status from the server
  Future<void> _fetchDownloadStatus() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _downloads = await _pyLoadApiRepository.getDownloadStatus(server);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Start polling downloads every second
  void _startPolling() {
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

  /// Stop polling downloads
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
