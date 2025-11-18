import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';

import 'add_server_viewmodel_test.mocks.dart';

@GenerateMocks([IServerRepository, IPyLoadApiRepository])
void main() {
  group('AddServerViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late AddServerViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      viewModel = AddServerViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
      );
    });

    test('validateAndAddServer throws error when IP is empty', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '',
          port: '8000',
          username: 'user',
          password: 'pass',
          protocol: 'http',
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('IP or hostname is required'),
          ),
        ),
      );
    });

    test('validateAndAddServer throws error when port is invalid', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: 'invalid',
          username: 'user',
          password: 'pass',
          protocol: 'http',
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Port must be a valid number'),
          ),
        ),
      );
    });

    test(
      'validateAndAddServer throws error when port is out of range',
      () async {
        expect(
          () => viewModel.validateAndAddServer(
            name: 'Test Server',
            ip: '192.168.1.1',
            port: '99999',
            username: 'user',
            password: 'pass',
            protocol: 'http',
          ),
          throwsA(
            isA<String>().having(
              (msg) => msg,
              'message',
              contains('Port must be between 1 and 65535'),
            ),
          ),
        );
      },
    );

    test('validateAndAddServer throws error when username is empty', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          username: '',
          password: 'pass',
          protocol: 'http',
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Username is required'),
          ),
        ),
      );
    });

    test('validateAndAddServer throws error when password is empty', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          username: 'user',
          password: '',
          protocol: 'http',
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Password is required'),
          ),
        ),
      );
    });

    test(
      'validateAndAddServer throws error when server already exists',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => true);

        expect(
          () => viewModel.validateAndAddServer(
            name: 'Test Server',
            ip: '192.168.1.1',
            port: '8000',
            username: 'user',
            password: 'pass',
            protocol: 'http',
          ),
          throwsA(
            isA<String>().having(
              (msg) => msg,
              'message',
              contains('A server with this IP and port already exists'),
            ),
          ),
        );

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
      },
    );

    test(
      'validateAndAddServer calls testServerConnection and addServer on success',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => false);

        final server = await viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          username: 'user',
          password: 'pass',
          protocol: 'http',
        );

        expect(server.ip, '192.168.1.1');
        expect(server.port, 8000);
        expect(server.username, 'user');
        expect(server.password, 'pass');
        expect(server.protocol, 'http');
        expect(server.name, 'Test Server');

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
      },
    );

    test('validateAndAddServer defaults name to pyLoad when empty', () async {
      when(
        mockServerRepository.serverExists('192.168.1.1', 8000),
      ).thenAnswer((_) async => false);

      final server = await viewModel.validateAndAddServer(
        name: '',
        ip: '192.168.1.1',
        port: '8000',
        username: 'user',
        password: 'pass',
        protocol: 'http',
      );

      expect(server.name, 'pyLoad');
      expect(server.ip, '192.168.1.1');
      expect(server.port, 8000);

      verify(mockServerRepository.serverExists('192.168.1.1', 8000)).called(1);
    });

    test(
      'validateAndAddServer defaults name to pyLoad when only whitespace',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => false);

        final server = await viewModel.validateAndAddServer(
          name: '   ',
          ip: '192.168.1.1',
          port: '8000',
          username: 'user',
          password: 'pass',
          protocol: 'http',
        );

        expect(server.name, 'pyLoad');
        expect(server.ip, '192.168.1.1');
        expect(server.port, 8000);

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
      },
    );
  });
}
