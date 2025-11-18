import 'package:flutter/material.dart';
import 'server_overview/ui/server_overview.dart';
import 'add_server/ui/add_server.dart';
import 'server/ui/server.dart';
import 'download_detail/ui/download_detail.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F5),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E3A5F)),
          bodyMedium: TextStyle(color: Color(0xFF1E3A5F)),
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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E3A5F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A5F),
          elevation: 0,
        ),
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
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const ServersScreen(),
        '/add-server': (context) => const AddServerScreen(),
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
