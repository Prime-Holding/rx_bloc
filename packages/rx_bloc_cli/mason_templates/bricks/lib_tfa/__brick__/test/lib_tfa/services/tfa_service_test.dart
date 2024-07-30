import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/lib_router/router.dart';
import 'package:{{project_name}}/lib_router/services/router_service.dart';
import 'package:{{project_name}}/lib_tfa/models/payload/actions/tfa_address_payload.dart';
import 'package:{{project_name}}/lib_tfa/models/payload/actions/tfa_unlock_payload.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_method.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_response.dart';
import 'package:{{project_name}}/lib_tfa/repositories/tfa_repository.dart';
import 'package:{{project_name}}/lib_tfa/services/tfa_service.dart';

import 'tfa_service_test.mocks.dart';

@GenerateMocks([TFARepository, RouterService])
void main() {
  late TFAService service;
  late MockTFARepository mockTFARepository;
  late MockRouterService mockRouterService;

  setUp(() {
    mockTFARepository = MockTFARepository();
    mockRouterService = MockRouterService();
    service = TFAService(mockTFARepository, mockRouterService);
  });

  tearDown(() {
    reset(mockTFARepository);
    reset(mockRouterService);
    service.dispose();
  });

  group('TFAService', () {
    test('authenticate emits correct responses', () async {
      // Unlock actions
      final unlockPayload = TFAUnlockPayload();

      when(
        mockTFARepository.initiate(
          action: unlockPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      when(mockRouterService.push<Result<TFAResponse>>(
        const TFAPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseOtp('1')));

      when(mockRouterService.push<Result<TFAResponse>>(
        const TFAOtpRoute('1'),
        extra: _Stub.responseOtp('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('1')));

      // Change address action
      final addressPayload = TFAAddressPayload(
        city: 'Plovdiv',
        countryCode: 'BG',
        streetAddress: '',
      );

      when(
        mockTFARepository.initiate(
          action: addressPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseOtp('2'));

      when(mockRouterService.push<Result<TFAResponse>>(
        const TFAOtpRoute('2'),
        extra: _Stub.responseOtp('2'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('2')));

      final responses = <TFAResponse>[];
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

      // Test the [TFAService.onResponse] stream to contain all responses from both actions
      expect(responses, [
        _Stub.responsePinBiometric('1'),
        _Stub.responseOtp('1'),
        _Stub.responseComplete('1'),
        _Stub.responseOtp('2'),
        _Stub.responseComplete('2'),
      ]);
    });

    test('authenticate emits complete method', () async {
      final payload = TFAUnlockPayload();

      when(
        mockTFARepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseComplete('1'));

      final responses = <TFAResponse>[];
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
      final payload = TFAUnlockPayload();

      when(mockRouterService.push<Result<TFAResponse>>(
        const TFAPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.error(Exception('Router error')));

      when(
        mockTFARepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      final responses = <TFAResponse>[];
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
    final payload = TFAUnlockPayload();

    final responses = <TFAResponse>[];
    service.onResponse.listen(responses.add);

    when(
      mockTFARepository.initiate(
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
  static TFAResponse responseComplete(String transactionId) => TFAResponse(
        authMethod: TFAMethod.complete,
        transactionId: transactionId,
        securityToken: 'completeToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static TFAResponse responsePinBiometric(String transactionId) => TFAResponse(
        authMethod: TFAMethod.pinBiometric,
        transactionId: transactionId,
        securityToken: 'pinBiometricToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static TFAResponse responseOtp(String transactionId) => TFAResponse(
        authMethod: TFAMethod.otp,
        transactionId: transactionId,
        securityToken: 'otpToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );
}
