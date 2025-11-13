import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'features/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const App());
}
