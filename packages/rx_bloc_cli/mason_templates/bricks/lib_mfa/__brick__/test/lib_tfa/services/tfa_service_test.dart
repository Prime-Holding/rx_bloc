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

@GenerateMocks([MFARepository, RouterService])
void main() {
  late MFAService service;
  late MockMFARepository mockMFARepository;
  late MockRouterService mockRouterService;

  setUp(() {
    mockMFARepository = MockMFARepository();
    mockRouterService = MockRouterService();
    service = MFAService(mockMFARepository, mockRouterService);
  });

  tearDown(() {
    reset(mockMFARepository);
    reset(mockRouterService);
    service.dispose();
  });

  group('MFAService', () {
    test('authenticate emits correct responses', () async {
      // Unlock actions
      final unlockPayload = MFAUnlockPayload();

      when(
        mockMFARepository.initiate(
          action: unlockPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      when(mockRouterService.push<Result<MFAResponse>>(
        const MFAPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseOtp('1')));

      when(mockRouterService.push<Result<MFAResponse>>(
        const MFAOtpRoute('1'),
        extra: _Stub.responseOtp('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('1')));

      // Change address action
      final addressPayload = MFAAddressPayload(
        city: 'Plovdiv',
        countryCode: 'BG',
        streetAddress: '',
      );

      when(
        mockMFARepository.initiate(
          action: addressPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseOtp('2'));

      when(mockRouterService.push<Result<MFAResponse>>(
        const MFAOtpRoute('2'),
        extra: _Stub.responseOtp('2'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('2')));

      final responses = <MFAResponse>[];
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

      // Test the [MFAService.onResponse] stream to contain all responses from both actions
      expect(responses, [
        _Stub.responsePinBiometric('1'),
        _Stub.responseOtp('1'),
        _Stub.responseComplete('1'),
        _Stub.responseOtp('2'),
        _Stub.responseComplete('2'),
      ]);
    });

    test('authenticate emits complete method', () async {
      final payload = MFAUnlockPayload();

      when(
        mockMFARepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseComplete('1'));

      final responses = <MFAResponse>[];
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
      final payload = MFAUnlockPayload();

      when(mockRouterService.push<Result<MFAResponse>>(
        const MFAPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.error(Exception('Router error')));

      when(
        mockMFARepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      final responses = <MFAResponse>[];
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
    final payload = MFAUnlockPayload();

    final responses = <MFAResponse>[];
    service.onResponse.listen(responses.add);

    when(
      mockMFARepository.initiate(
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
  static MFAResponse responseComplete(String transactionId) => MFAResponse(
        authMethod: MFAMethod.complete,
        transactionId: transactionId,
        securityToken: 'completeToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static MFAResponse responsePinBiometric(String transactionId) => MFAResponse(
        authMethod: MFAMethod.pinBiometric,
        transactionId: transactionId,
        securityToken: 'pinBiometricToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static MFAResponse responseOtp(String transactionId) => MFAResponse(
        authMethod: MFAMethod.otp,
        transactionId: transactionId,
        securityToken: 'otpToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );
}
