{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../../base/repositories/pin_code_repository.dart';
import '../../../models/mfa_method_request.dart';
import '../../../models/mfa_response.dart';
import '../../../repositories/mfa_repository.dart';
import '../models/mfa_pin_code_payload.dart';

class MfaPinCodeService extends PinCodeService {
  final MfaRepository _mfaRepository;
  final MfaResponse _lastMfaResponse;
  final PinCodeRepository _pinCodeRepository;

  MfaPinCodeService({
    required MfaRepository mfaRepository,
    required MfaResponse mfaResponse,
    required PinCodeRepository pinCodeRepository,
  })  : _mfaRepository = mfaRepository,
        _lastMfaResponse = mfaResponse,
        _pinCodeRepository = pinCodeRepository;

  static const storedPin = 'storedPin';

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> savePinCodeInSecureStorage(String pinCode) async => false;

  ///TODO: Implement encryption
  @override
  Future<String> encryptPinCode(String pinCode) async => pinCode;

  @override
  Future<dynamic> verifyPinCode(String pinCode) => _mfaRepository.authenticate(
        transactionId: _lastMfaResponse.transactionId,
        request: MfaMethodRequest(
          securityToken: _lastMfaResponse.securityToken,
          payload: MfaPinCodePayload(
            code: pinCode,
          ),
        ),
      );
}