import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart' as app_models;
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final ISettingsRepository _settingsRepository;
  app_models.AppSettings _settings = const app_models.AppSettings();

  SettingsViewModel({required ISettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository {
    _loadSettings();
  }

  app_models.AppSettings get settings => _settings;
  app_models.ThemeMode get themeMode => _settings.themeMode;
  bool get skipSelectionScreenIfOnlyOneServer =>
      _settings.skipSelectionScreenIfOnlyOneServer;

  Future<void> _loadSettings() async {
    _settings = await _settingsRepository.loadSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(app_models.ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _settingsRepository.saveSettings(_settings);
    notifyListeners();
    // TODO: Implement theme change in the app
  }

  Future<void> setSkipSelectionScreenIfOnlyOneServer(bool value) async {
    _settings = _settings.copyWith(skipSelectionScreenIfOnlyOneServer: value);
    await _settingsRepository.saveSettings(_settings);
    notifyListeners();
    // TODO: Implement skip selection screen logic
  }
}
