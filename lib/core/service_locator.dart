import 'package:get_it/get_it.dart';
import 'package:omni_for_pyload/data/repositories/pyload_api_repository.dart';
import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';

final getIt = GetIt.instance;

/// Registers all dependencies for the application
Future<void> setupServiceLocator() async {
  // Register repositories
  final serverRepository = ServerRepository();
  await serverRepository.initialize();
  getIt.registerSingleton<IServerRepository>(serverRepository);

  getIt.registerSingleton<IPyLoadApiRepository>(PyLoadApiRepository());
}
