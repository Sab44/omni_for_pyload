import 'package:flutter/material.dart';
import 'server_overview/ui/server_overview.dart';
import 'add_server/ui/add_server.dart';
import 'server/ui/server.dart';
import 'download_detail/ui/download_detail.dart';
import 'settings/ui/settings_screen.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart' as app_models;

// Global notifier for theme changes
final ValueNotifier<app_models.ThemeMode> themeNotifier = ValueNotifier(
  app_models.ThemeMode.system,
);

class App extends StatefulWidget {
  final app_models.AppSettings initialSettings;

  const App({required this.initialSettings, super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late app_models.ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialSettings.themeMode;
    themeNotifier.value = _themeMode;
    themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      _themeMode = themeNotifier.value;
    });
  }

  ThemeMode _convertToFlutterThemeMode(app_models.ThemeMode mode) {
    switch (mode) {
      case app_models.ThemeMode.light:
        return ThemeMode.light;
      case app_models.ThemeMode.dark:
        return ThemeMode.dark;
      case app_models.ThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primaryColor: const Color(0xFF1E3A5F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFECECEC),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFECECEC),
          selectedItemColor: Color(0xFF5081CF),
        ),
        cardTheme: const CardThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E3A5F)),
          bodyMedium: TextStyle(color: Color(0xFF1E3A5F), fontSize: 12),
          titleLarge: TextStyle(color: Color(0xFF1E3A5F)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A5F),
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1E3A5F),
          foregroundColor: Colors.white,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF12253F),
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF07051F),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF07051F),
          selectedItemColor: Color(0xFF92B0DF),
        ),
        cardTheme: const CardThemeData(color: Color(0xFF07051F)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E3A5F),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E3A5F),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFF1E3A5F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      themeMode: _convertToFlutterThemeMode(_themeMode),
      initialRoute: '/',
      routes: {
        '/': (context) => const ServerOverviewScreen(),
        '/add-server': (context) => const AddServerScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/server') {
          final server = settings.arguments as Server;
          return MaterialPageRoute(
            builder: (context) => ServerScreen(server: server),
          );
        }
        if (settings.name == '/download-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          final server = args['server'] as Server;
          final packageId = args['packageId'] as int;
          return MaterialPageRoute(
            builder: (context) =>
                DownloadDetailScreen(server: server, packageId: packageId),
          );
        }
        return null;
      },
    );
  }
}
