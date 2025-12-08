import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';

class SettingsRepository implements ISettingsRepository {
  static const String _boxName = 'settings';
  static const String _settingsKey = 'app_settings';

  Box? _box;

  Future<void> _ensureBoxOpen() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  @override
  Future<AppSettings> loadSettings() async {
    await _ensureBoxOpen();
    final json = _box!.get(_settingsKey);
    if (json == null) {
      return const AppSettings();
    }
    return AppSettings.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _ensureBoxOpen();
    await _box!.put(_settingsKey, settings.toJson());
  }
}
