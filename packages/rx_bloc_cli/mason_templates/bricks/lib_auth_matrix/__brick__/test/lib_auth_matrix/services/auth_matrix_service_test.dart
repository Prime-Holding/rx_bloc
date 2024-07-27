import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/lib_auth_matrix/models/auth_matrix_method.dart';
import 'package:{{project_name}}/lib_auth_matrix/models/auth_matrix_response.dart';
import 'package:{{project_name}}/lib_auth_matrix/models/payload/actions/auth_matrix_address_payload.dart';
import 'package:{{project_name}}/lib_auth_matrix/models/payload/actions/auth_matrix_unlock_payload.dart';
import 'package:{{project_name}}/lib_auth_matrix/repositories/auth_matrix_repository.dart';
import 'package:{{project_name}}/lib_auth_matrix/services/auth_matrix_service.dart';
import 'package:{{project_name}}/lib_router/router.dart';
import 'package:{{project_name}}/lib_router/services/router_service.dart';

import 'auth_matrix_service_test.mocks.dart';

@GenerateMocks([AuthMatrixRepository, RouterService])
void main() {
  late AuthMatrixService authMatrixService;
  late MockAuthMatrixRepository mockAuthMatrixRepository;
  late MockRouterService mockRouterService;

  setUp(() {
    mockAuthMatrixRepository = MockAuthMatrixRepository();
    mockRouterService = MockRouterService();
    authMatrixService =
        AuthMatrixService(mockAuthMatrixRepository, mockRouterService);
  });

  tearDown(() {
    reset(mockAuthMatrixRepository);
    reset(mockRouterService);
    authMatrixService.dispose();
  });

  group('AuthMatrixService', () {
    test('initiateAuthMatrix emits correct responses', () async {
      // Unlock actions
      final unlockPayload = AuthMatrixUnlockPayload();

      when(
        mockAuthMatrixRepository.initiate(
          action: unlockPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      when(mockRouterService.push<Result<AuthMatrixResponse>>(
        const AuthMatrixPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseOtp('1')));

      when(mockRouterService.push<Result<AuthMatrixResponse>>(
        const AuthMatrixOtpRoute('1'),
        extra: _Stub.responseOtp('1'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('1')));

      // Change address action
      final addressPayload = AuthMatrixAddressPayload(
        city: 'Plovdiv',
        countryCode: 'BG',
        streetAddress: '',
      );

      when(
        mockAuthMatrixRepository.initiate(
          action: addressPayload.type,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseOtp('2'));

      when(mockRouterService.push<Result<AuthMatrixResponse>>(
        const AuthMatrixOtpRoute('2'),
        extra: _Stub.responseOtp('2'),
      )).thenAnswer((_) async => Result.success(_Stub.responseComplete('2')));

      final responses = <AuthMatrixResponse>[];
      authMatrixService.onResponse.listen(responses.add);

      // Test the unlock action
      await expectLater(
        authMatrixService.initiateAuthMatrix(payload: unlockPayload),
        emitsInOrder([
          _Stub.responsePinBiometric('1'),
          _Stub.responseOtp('1'),
          _Stub.responseComplete('1'),
          emitsDone,
        ]),
      );

      // Test the change address actions
      await expectLater(
        authMatrixService.initiateAuthMatrix(payload: addressPayload),
        emitsInOrder([
          _Stub.responseOtp('2'),
          _Stub.responseComplete('2'),
          emitsDone,
        ]),
      );

      // Test the [AuthMatrixService.onResponse] stream to contain all responses from both actions
      expect(responses, [
        _Stub.responsePinBiometric('1'),
        _Stub.responseOtp('1'),
        _Stub.responseComplete('1'),
        _Stub.responseOtp('2'),
        _Stub.responseComplete('2'),
      ]);
    });

    test('initiateAuthMatrix emits complete method', () async {
      final payload = AuthMatrixUnlockPayload();

      when(
        mockAuthMatrixRepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responseComplete('1'));

      final responses = <AuthMatrixResponse>[];
      authMatrixService.onResponse.listen(responses.add);

      await expectLater(
        authMatrixService.initiateAuthMatrix(payload: payload),
        emitsInOrder([
          _Stub.responseComplete('1'),
          emitsDone,
        ]),
      );

      expect(responses, [
        _Stub.responseComplete('1'),
      ]);
    });

    test('initiateAuthMatrix handles router service errors', () async {
      final payload = AuthMatrixUnlockPayload();

      when(mockRouterService.push<Result<AuthMatrixResponse>>(
        const AuthMatrixPinBiometricsRoute('1'),
        extra: _Stub.responsePinBiometric('1'),
      )).thenAnswer((_) async => Result.error(Exception('Router error')));

      when(
        mockAuthMatrixRepository.initiate(
          action: anyNamed('action'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => _Stub.responsePinBiometric('1'));

      final responses = <AuthMatrixResponse>[];
      authMatrixService.onResponse.listen(responses.add);

      await expectLater(
        authMatrixService.initiateAuthMatrix(payload: payload),
        emitsInOrder([
          _Stub.responsePinBiometric('1'),
          emitsError(isA<Exception>()),
        ]),
      );

      expect(responses, [_Stub.responsePinBiometric('1')]);
    });
  });

  test('initiateAuthMatrix handles repository errors', () async {
    final payload = AuthMatrixUnlockPayload();

    final responses = <AuthMatrixResponse>[];
    authMatrixService.onResponse.listen(responses.add);

    when(
      mockAuthMatrixRepository.initiate(
        action: anyNamed('action'),
        request: anyNamed('request'),
      ),
    ).thenAnswer((_) async => throw Exception('Repository error'));

    await expectLater(
      authMatrixService.initiateAuthMatrix(payload: payload),
      emitsError(isA<Exception>()),
    );

    expect(responses, []);
  });
}

class _Stub {
  static AuthMatrixResponse responseComplete(String transactionId) =>
      AuthMatrixResponse(
        authMethod: AuthMatrixMethod.complete,
        transactionId: transactionId,
        securityToken: 'completeToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static AuthMatrixResponse responsePinBiometric(String transactionId) =>
      AuthMatrixResponse(
        authMethod: AuthMatrixMethod.pinBiometric,
        transactionId: transactionId,
        securityToken: 'pinBiometricToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );

  static AuthMatrixResponse responseOtp(String transactionId) =>
      AuthMatrixResponse(
        authMethod: AuthMatrixMethod.otp,
        transactionId: transactionId,
        securityToken: 'otpToken',
        documentIds: [1],
        expires: '2024-07-20T20:18:04.000Z',
      );
}
