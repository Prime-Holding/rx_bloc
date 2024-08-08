import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/lib_router/router.dart';
import 'package:{{project_name}}/lib_router/services/router_service.dart';
import 'package:{{project_name}}/lib_mfa/models/payload/actions/mfa_address_payload.dart';
import 'package:{{project_name}}/lib_mfa/models/payload/actions/mfa_unlock_payload.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_method.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_response.dart';
import 'package:{{project_name}}/lib_mfa/repositories/mfa_repository.dart';
import 'package:{{project_name}}/lib_mfa/services/mfa_service.dart';

import 'mfa_service_test.mocks.dart';

@GenerateMocks([MfaRepository, RouterService])
void main() {
  late MfaService service;
  late MockMfaRepository mockMfaRepository;
  late MockRouterService mockRouterService;

  setUp(() {
    mockMfaRepository = MockMfaRepository();
    mockRouterService = MockRouterService();
    service = MfaService(mockMfaRepository, mockRouterService);
  });

  tearDown(() {
    reset(mockMfaRepository);
    reset(mockRouterService);
    service.dispose();
  });

  group('MfaService', () {
    test('authenticate emits correct responses', () async {
      // Unlock actions
      final unlockPayload = MfaUnlockPayload();

      when(
        mockMfaRepository.initiate(
          action: unlockPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      when(mockRouterService.push<Result<MfaResponse>>(
        const MfaPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseOtp('1')));

      when(mockRouterService.push<Result<MfaResponse>>(
        const MfaOtpRoute('1'),
        extra: _Stub.responseOtp('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('1')));

      // Change address action
      final addressPayload = MfaAddressPayload(
        city: 'Plovdiv',
        countryCode: 'BG',
        streetAddress: '',
      );

      when(
        mockMfaRepository.initiate(
          action: addressPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseOtp('2'));

      when(mockRouterService.push<Result<MfaResponse>>(
        const MfaOtpRoute('2'),
        extra: _Stub.responseOtp('2'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('2')));

      final responses = <MfaResponse>[];
      service.onResponse.listen(responses.add);

      // Test the unlock action
      await expectLater(
        service.authenticate(payload: unlockPayload),
        emitsInOrder([
          _Stub.responsePinBiometric('1'),
          _Stub.responseOtp('1'),
          _Stub.responseComplete('1'),
          emitsDone,
        ]),
      );

      // Test the change address actions
      await expectLater(
        service.authenticate(payload: addressPayload),
        emitsInOrder([
          _Stub.responseOtp('2'),
          _Stub.responseComplete('2'),
          emitsDone,
        ]),
      );

      // Test the [MfaService.onResponse] stream to contain all responses from both actions
      expect(responses, [
        _Stub.responsePinBiometric('1'),
        _Stub.responseOtp('1'),
        _Stub.responseComplete('1'),
        _Stub.responseOtp('2'),
        _Stub.responseComplete('2'),
      ]);
    });

    test('authenticate emits complete method', () async {
      final payload = MfaUnlockPayload();

      when(
        mockMfaRepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseComplete('1'));

      final responses = <MfaResponse>[];
      service.onResponse.listen(responses.add);

      await expectLater(
        service.authenticate(payload: payload),
        emitsInOrder([
          _Stub.responseComplete('1'),
          emitsDone,
        ]),
      );

      expect(responses, [
        _Stub.responseComplete('1'),
      ]);
    });

    test('authenticate handles router service errors', () async {
      final payload = MfaUnlockPayload();

      when(mockRouterService.push<Result<MfaResponse>>(
        const MfaPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.error(Exception('Router error')));

      when(
        mockMfaRepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      final responses = <MfaResponse>[];
      service.onResponse.listen(responses.add);

      await expectLater(
        service.authenticate(payload: payload),
        emitsInOrder([
          _Stub.responsePinBiometric('1'),
          emitsError(isA<Exception>()),
        ]),
      );

      expect(responses, [_Stub.responsePinBiometric('1')]);
    });
  });

  test('authenticate handles repository errors', () async {
    final payload = MfaUnlockPayload();

    final responses = <MfaResponse>[];
    service.onResponse.listen(responses.add);

    when(
      mockMfaRepository.initiate(
        action: anyNamed('action'),
        request: anyNamed('request'),
      ),
    ).thenAnswer((_) async => throw Exception('Repository error'));

    await expectLater(
      service.authenticate(payload: payload),
      emitsError(isA<Exception>()),
    );

    expect(responses, []);
  });
}

class _Stub {
  static MfaResponse responseComplete(String transactionId) => MfaResponse(
        authMethod: MfaMethod.complete,
        transactionId: transactionId,
        securityToken: 'completeToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static MfaResponse responsePinBiometric(String transactionId) => MfaResponse(
        authMethod: MfaMethod.pinBiometric,
        transactionId: transactionId,
        securityToken: 'pinBiometricToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static MfaResponse responseOtp(String transactionId) => MfaResponse(
        authMethod: MfaMethod.otp,
        transactionId: transactionId,
        securityToken: 'otpToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );
}
