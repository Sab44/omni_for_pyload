import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_overview_viewmodel.dart';

import 'server_overview_viewmodel_test.mocks.dart';

@GenerateMocks([IServerRepository, IPyLoadApiRepository])
void main() {
  group('ServerOverviewViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late ServerOverviewViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      viewModel = ServerOverviewViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
      );
    });

    test('loadServers retrieves and updates server list', () async {
      final testServers = [
        Server(
          ip: '192.168.1.1',
          port: 8000,
          username: 'user1',
          password: 'pass1',
          protocol: 'http',
        ),
        Server(
          ip: '192.168.1.2',
          port: 8001,
          username: 'user2',
          password: 'pass2',
          protocol: 'https',
        ),
      ];

      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => testServers);

      await viewModel.loadServers();

      expect(viewModel.servers, equals(testServers));
      expect(viewModel.servers.length, 2);
      verify(mockServerRepository.getAllServers()).called(1);
    });

    test('loadServers returns empty list when no servers exist', () async {
      when(mockServerRepository.getAllServers()).thenAnswer((_) async => []);

      await viewModel.loadServers();

      expect(viewModel.servers, isEmpty);
      verify(mockServerRepository.getAllServers()).called(1);
    });

    test('removeServer removes server from list and repository', () async {
      final server = Server(
        ip: '192.168.1.1',
        port: 8000,
        username: 'user1',
        password: 'pass1',
        protocol: 'http',
      );

      final initialServers = [server];
      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => initialServers);

      when(
        mockServerRepository.removeServer('192.168.1.1:8000'),
      ).thenAnswer((_) async => Future<void>.value());

      // Load servers first
      await viewModel.loadServers();
      expect(viewModel.servers.length, 1);

      // Then remove one
      await viewModel.removeServer(server);

      expect(viewModel.servers, isEmpty);
      verify(mockServerRepository.removeServer('192.168.1.1:8000')).called(1);
    });

    test('refresh reloads servers from repository', () async {
      final testServers = [
        Server(
          ip: '192.168.1.1',
          port: 8000,
          username: 'user1',
          password: 'pass1',
          protocol: 'http',
        ),
      ];

      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => testServers);

      await viewModel.refresh();

      expect(viewModel.servers, equals(testServers));
      verify(mockServerRepository.getAllServers()).called(1);
    });

    test('fetchOnlineStatus returns status', () async {
      final server = Server(
        ip: '192.168.1.1',
        port: 8000,
        username: 'user1',
        password: 'pass1',
        protocol: 'http',
      );

      when(
        mockPyLoadApiRepository.testServerConnection(server),
      ).thenAnswer((_) async => Future<void>.value());

      final status = await viewModel.fetchOnlineStatus(server);

      expect(status, equals('online'));
      verify(mockPyLoadApiRepository.testServerConnection(server)).called(1);
    });

    test('fetchOnlineStatus returns offline when connection fails', () async {
      final server = Server(
        ip: '192.168.1.1',
        port: 8000,
        username: 'user1',
        password: 'pass1',
        protocol: 'http',
      );

      when(
        mockPyLoadApiRepository.testServerConnection(server),
      ).thenThrow('Connection failed');

      final status = await viewModel.fetchOnlineStatus(server);

      expect(status, equals('offline'));
      verify(mockPyLoadApiRepository.testServerConnection(server)).called(1);
    });
  });
}
