import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class ServerViewModel extends ChangeNotifier {
  final IPyLoadApiRepository _pyLoadApiRepository;
  final Server server;
  int _selectedTabIndex = 0;

  ServerViewModel({
    required this.server,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _pyLoadApiRepository = pyLoadApiRepository;

  int get selectedTabIndex => _selectedTabIndex;

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
}
