import 'package:flutter/material.dart';
import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'features/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServerRepository.initialize();
  runApp(const App());
}
