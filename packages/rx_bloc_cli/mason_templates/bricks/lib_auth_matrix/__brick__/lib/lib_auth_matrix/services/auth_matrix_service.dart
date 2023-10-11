{{> licence.dart }}

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

/// Service that handles the auth matrix flow
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

  ///Function used to generate the end to end id
  String generateEndToEndId() => const Uuid().v4();

  ///Function used to initialise the auth matrix flow,
  ///and navigate to the correct screen based on the server response
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
        case AuthMatrixActionType.pinOnly:
          await _routerService.go(
              AuthMatrixPinBiometricsRoute(
                payload.endToEndId,
              ),
              response);
        case AuthMatrixActionType.pinAndOtp:
          await _routerService.go(
              AuthMatrixOtpRoute(
                payload.endToEndId,
              ),
              response);
        case AuthMatrixActionType.none:
          _routerService.pop();
          return;
      }
    }
    return;
  }

  ///Function used to verify the auth matrix flow
  ///Adds the response to the [_flowEvents] stream
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

  ///Function used to cancel the auth matrix flow
  ///Adds the error to the [_flowEvents] stream
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

  @override
  ///Function used to verify auth method once the user enters the OTP code
  Future<dynamic> confirmPhoneCode(String code) async {
    await verifyAuthMethod(_flowEvents.value, _endToEndId, _userData, code);
    return true;
  }

  @override
  Future<String> getFullPhoneNumber() async => '+1234567890';

  @override
  Future<String> updatePhoneNumber(String newNumber) async => '+1234567890';

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

  @override
  ///Function used to verify auth method once the user enters the pin/biometrics code
  Future<bool> verifyPinCode(String pinCode) async {
    await verifyAuthMethod(_flowEvents.value, _endToEndId, _userData, pinCode);
    return true;
  }

  @override
  Future<String?> getPinCode() => Future.value('1111');

  @override
  Future<int> getPinLength() => Future.value(4);

  @override
  Future<bool> isPinCodeInSecureStorage() => Future.value(true);

  @override
  Future<String> encryptPinCode(String pinCode) async => pinCode;
}
