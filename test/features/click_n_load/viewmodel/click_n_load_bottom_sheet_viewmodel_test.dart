import 'package:flutter_test/flutter_test.dart';
import 'package:omni_for_pyload/features/click_n_load/viewmodel/click_n_load_bottom_sheet_viewmodel.dart';

void main() {
  group('ClickNLoadBottomSheetViewModel', () {
    group('validate', () {
      late ClickNLoadBottomSheetViewModel viewModel;

      setUp(() {
        viewModel = ClickNLoadBottomSheetViewModel(
          onSave: (_, _, _, _) async => true,
        );
      });

      test('returns error when IP is empty', () {
        final result = viewModel.validate(
          ip: '',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'IP or hostname is required',
        );
      });

      test('returns error when IP is only whitespace', () {
        final result = viewModel.validate(
          ip: '   ',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'IP or hostname is required',
        );
      });

      test('returns error when port is not a number', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: 'invalid',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'Port must be a valid number',
        );
      });

      test('returns error when port is empty', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'Port must be a valid number',
        );
      });

      test('returns error when port is zero', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '0',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'Port must be between 1 and 65535',
        );
      });

      test('returns error when port is negative', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '-1',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'Port must be between 1 and 65535',
        );
      });

      test('returns error when port exceeds 65535', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '65536',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationError>());
        expect(
          (result as ClickNLoadValidationError).message,
          'Port must be between 1 and 65535',
        );
      });

      test('returns success with valid configuration', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        final success = result as ClickNLoadValidationSuccess;
        expect(success.ip, '192.168.1.1');
        expect(success.port, 9666);
        expect(success.protocol, 'http');
        expect(success.allowInsecureConnections, false);
      });

      test('returns success with https and insecure connections allowed', () {
        final result = viewModel.validate(
          ip: 'myserver.local',
          portText: '443',
          protocol: 'https',
          allowInsecureConnections: true,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        final success = result as ClickNLoadValidationSuccess;
        expect(success.ip, 'myserver.local');
        expect(success.port, 443);
        expect(success.protocol, 'https');
        expect(success.allowInsecureConnections, true);
      });

      test('trims whitespace from IP', () {
        final result = viewModel.validate(
          ip: '  192.168.1.1  ',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        expect((result as ClickNLoadValidationSuccess).ip, '192.168.1.1');
      });

      test('trims whitespace from port', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '  9666  ',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        expect((result as ClickNLoadValidationSuccess).port, 9666);
      });

      test('accepts minimum valid port (1)', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '1',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        expect((result as ClickNLoadValidationSuccess).port, 1);
      });

      test('accepts maximum valid port (65535)', () {
        final result = viewModel.validate(
          ip: '192.168.1.1',
          portText: '65535',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(result, isA<ClickNLoadValidationSuccess>());
        expect((result as ClickNLoadValidationSuccess).port, 65535);
      });
    });

    group('validateAndSave', () {
      test('calls onError and returns false when validation fails', () async {
        String? errorMessage;
        final viewModel = ClickNLoadBottomSheetViewModel(
          onSave: (_, _, _, _) async => true,
        );

        final result = await viewModel.validateAndSave(
          ip: '',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
          onError: (message) => errorMessage = message,
        );

        expect(result, false);
        expect(errorMessage, 'IP or hostname is required');
      });

      test('calls onSave and returns true when validation succeeds', () async {
        String? savedIp;
        int? savedPort;
        String? savedProtocol;
        bool? savedAllowInsecure;

        final viewModel = ClickNLoadBottomSheetViewModel(
          onSave: (ip, port, protocol, allowInsecure) async {
            savedIp = ip;
            savedPort = port;
            savedProtocol = protocol;
            savedAllowInsecure = allowInsecure;
            return true;
          },
        );

        final result = await viewModel.validateAndSave(
          ip: '192.168.1.1',
          portText: '9666',
          protocol: 'https',
          allowInsecureConnections: true,
          onError: (_) {},
        );

        expect(result, true);
        expect(savedIp, '192.168.1.1');
        expect(savedPort, 9666);
        expect(savedProtocol, 'https');
        expect(savedAllowInsecure, true);
      });

      test('returns false when onSave returns false', () async {
        final viewModel = ClickNLoadBottomSheetViewModel(
          onSave: (_, _, _, _) async => false,
        );

        final result = await viewModel.validateAndSave(
          ip: '192.168.1.1',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
          onError: (_) {},
        );

        expect(result, false);
      });

      test('does not call onError when onSave returns false', () async {
        bool errorCalled = false;
        final viewModel = ClickNLoadBottomSheetViewModel(
          onSave: (_, _, _, _) async => false,
        );

        await viewModel.validateAndSave(
          ip: '192.168.1.1',
          portText: '9666',
          protocol: 'http',
          allowInsecureConnections: false,
          onError: (_) => errorCalled = true,
        );

        expect(errorCalled, false);
      });
    });
  });
}
