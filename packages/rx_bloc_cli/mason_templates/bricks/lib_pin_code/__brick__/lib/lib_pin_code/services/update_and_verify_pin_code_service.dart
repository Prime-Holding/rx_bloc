{{> licence.dart }}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';
import '../../base/models/errors/error_model.dart';
import '../repository/pin_code_repository.dart';

class UpdateAndVerifyPinCodeService implements PinCodeService {
  UpdateAndVerifyPinCodeService(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  static const _firstPin = 'firstPin';
  static const _storedPin = 'storedPin';
  bool _isVerificationPinProcess = true;
  bool _isFromSessionTimeout = false;
  late String token;

  Future<void> deleteStoredPin() async {
    await _pinCodeRepository.writePinToStorage(_storedPin, null);
    await _pinCodeRepository.writePinToStorage(_firstPin, null);
    _isVerificationPinProcess = true;
  }

  Future<void> deleteSavedData() async {
    await _pinCodeRepository.writePinToStorage(_firstPin, null);
    _isVerificationPinProcess = true;
  }

  Future<bool> setPinCodeType(bool isFromSessionTimeout) async =>
      _isFromSessionTimeout = isFromSessionTimeout;

  @override
  Future<bool> isPinCodeInSecureStorage() async =>
      await _pinCodeRepository.readPinFromStorage(key: _storedPin) != null;

  Future<bool> checkIsPinCreated() async =>
      await _pinCodeRepository.getPinCode() != null;

  @override
  Future<String> encryptPinCode(String pinCode) async =>
      md5.convert(utf8.encode(pinCode)).toString();

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    if (_isFromSessionTimeout) {
      return await _pinCodeRepository.verifyPinCode(pinCode);
    }
    final firstPin =
        await _pinCodeRepository.readPinFromStorage(key: _firstPin);
    if (firstPin != null) {
      if (pinCode == firstPin) {
        await _pinCodeRepository.updatePinCode(pinCode);
        await _pinCodeRepository.writePinToStorage(_storedPin, pinCode);
        return true;
      }
      throw ErrorServerGenericModel(
        message: 'PIN code does not match',
      );
    }
    if (firstPin == null && _isVerificationPinProcess) {
      if (await _pinCodeRepository.verifyPinCode(
        pinCode,
        requestUpdateToken: true,
      )) {
        _isVerificationPinProcess = false;
        return true;
      }
      _isVerificationPinProcess = true;
      return false;
    }
    await _pinCodeRepository.writePinToStorage(_firstPin, pinCode);
    return true;
  }

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();
}
