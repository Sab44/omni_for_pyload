import 'package:omni_for_pyload/domain/models/app_settings.dart';

abstract class ISettingsRepository {
  /// Load app settings from local storage
  Future<AppSettings> loadSettings();

  /// Save app settings to local storage
  Future<void> saveSettings(AppSettings settings);
}
