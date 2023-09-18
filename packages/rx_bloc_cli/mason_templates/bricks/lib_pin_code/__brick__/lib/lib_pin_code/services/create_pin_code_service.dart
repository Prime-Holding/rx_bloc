{{> licence.dart }}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';
import '../repository/pin_code_repository.dart';

class CreatePinCodeService implements PinCodeService {
  CreatePinCodeService(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  static const _storedPin = 'storedPin';
  String? firstPin;

  Future<void> deleteSavedData() async => firstPin = null;

  Future<bool> deleteStoredPin() async {
    await _pinCodeRepository.writePinToStorage(_storedPin, null);
    return await getPinCode() == null;
  }

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    if (firstPin != null) {
      return true;
    }
    return null != await _pinCodeRepository.readPinFromStorage(key: _storedPin);
  }

  Future<bool> checkIsPinCreated() async =>
      await _pinCodeRepository.getPinCode() != null;

  @override
  Future<String> encryptPinCode(String pinCode) async =>
      md5.convert(utf8.encode(pinCode)).toString();

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    if (firstPin == null) {
      firstPin = pinCode;
      return true;
    }
    if (pinCode == firstPin) {
      await _pinCodeRepository.writePinToStorage(_storedPin, pinCode);
      return true;
    }
    throw ErrorWrongPin(errorMessage: '');
  }

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();
}
