enum ThemeMode { light, dark, system }

class AppSettings {
  final ThemeMode themeMode;
  final bool skipSelectionScreenIfOnlyOneServer;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.skipSelectionScreenIfOnlyOneServer = false,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? skipSelectionScreenIfOnlyOneServer,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      skipSelectionScreenIfOnlyOneServer:
          skipSelectionScreenIfOnlyOneServer ??
          this.skipSelectionScreenIfOnlyOneServer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'skipSelectionScreenIfOnlyOneServer': skipSelectionScreenIfOnlyOneServer,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      skipSelectionScreenIfOnlyOneServer:
          json['skipSelectionScreenIfOnlyOneServer'] ?? false,
    );
  }
}
