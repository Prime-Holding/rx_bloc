import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/models/errors/error_model.dart';
import '../../lib_router/router.dart';
import '../../lib_router/services/router_service.dart';
import '../models/action_request.dart';
import '../models/auth_matrix_action_type.dart';
import '../models/auth_matrix_cancel_model.dart';
import '../models/auth_matrix_response.dart';
import '../models/auth_matrix_verify.dart';
import '../repositories/auth_matrix_repository.dart';

class AuthMatrixService implements SmsCodeService, PinCodeService {
  AuthMatrixService(
    this._authMatrixRepository,
    this._routerService,
  );

  final RouterService _routerService;
  final AuthMatrixRepository _authMatrixRepository;
  final BehaviorSubject<AuthMatrixResponse> _flowEvents =
      BehaviorSubject<AuthMatrixResponse>();

  String _endToEndId = '';
  String _userData = '';

  String generateEndToEndId() => const Uuid().v4();

  Future<void> initialiseAuthMatrixFlow({
    required ActionRequest payload,
    required String userData,
  }) async {
    _flowEvents
        .add(await _authMatrixRepository.initiateAuthMatrix(payload: payload));
    _endToEndId = payload.endToEndId;
    _userData = userData;
    await for (AuthMatrixResponse response in _flowEvents) {
      switch (response.authZ) {
        case AuthMatrixActionType.none:
          _routerService.pop();
          return;
        case AuthMatrixActionType.pinAndOtp:
        case AuthMatrixActionType.pinOnly:
          await _navigateFunction(response, payload.endToEndId);
      }
    }
    return;
  }

  Future<void> _navigateFunction(
      AuthMatrixResponse response, String endToEndId) async {
    switch (response.authZ) {
      case AuthMatrixActionType.pinOnly:
        await _routerService.go(
            AuthMatrixPinBiometricsRoute(
              endToEndId,
            ),
            response);
      case AuthMatrixActionType.pinAndOtp:
        await _routerService.go(
            AuthMatrixOtpRoute(
              endToEndId,
            ),
            response);
      case AuthMatrixActionType.none:
        break;
    }
  }

  Future<void> verifyAuthMethod(
    AuthMatrixResponse authMatrixResponse,
    String endToEndId,
    String userData,
    String code,
  ) async {
    _flowEvents.add(
      await _authMatrixRepository
          .verifyAuthMatrix(
        payload: AuthMatrixVerify(
          transactionId: authMatrixResponse.transactionId,
          userData: userData,
          payload: {'code': code},
          action: authMatrixResponse.authZ,
          endToEndId: endToEndId,
        ),
      )
          .catchError(
        (error, stacktrace) {
          _flowEvents.addError(
            AccessDeniedErrorModel(),
          );
          throw AccessDeniedErrorModel();
        },
      ),
    );
  }

  Future<void> cancelAuthMatrix(
    String endToEndId,
    String transactionId,
  ) async {
    await _authMatrixRepository.cancelAuthMatrix(
      AuthMatrixCancelModel(endToEndId, transactionId),
    );
    _flowEvents.addError(AuthMatrixCanceledErrorModel());
  }

  void dispose() {
    _flowEvents.close();
  }

  ///OTP
  @override
  Future<dynamic> confirmPhoneCode(String code) async {
    await verifyAuthMethod(_flowEvents.value, _endToEndId, _userData, code);
    return true;
  }

  @override
  Future<String> getFullPhoneNumber() async => '+38164 1234567';

  @override
  Future<String> updatePhoneNumber(String newNumber) async => '+38164 1234567';

  @override
  Future<bool> sendConfirmationSms(String usersPhoneNumber) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  @override
  Future<int> getValidityTime(bool reset) async => 30;

  @override
  Future<int> getResendButtonThrottleTime(bool reset) async => 15;

  @override
  Future<int> getCodeLength() async => 4;

  ///PIN
  @override
  Future<bool> verifyPinCode(String pinCode) async {
    await verifyAuthMethod(_flowEvents.value, _endToEndId, _userData, pinCode);
    return true;
  }

  @override
  Future<String?> getPinCode() => Future.value('000');

  @override
  Future<int> getPinLength() => Future.value(3);

  @override
  Future<bool> isPinCodeInSecureStorage() => Future.value(true);

  @override
  Future<String> encryptPinCode(String pinCode) async => pinCode;
}
