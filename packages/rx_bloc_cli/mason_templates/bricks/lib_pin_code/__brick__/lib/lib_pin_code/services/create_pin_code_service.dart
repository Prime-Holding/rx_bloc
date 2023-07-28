{{> licence.dart }}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';
import '../repository/pin_code_repository.dart';

class CreatePinCodeService implements PinCodeService {
  CreatePinCodeService(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  static const _firstPin = 'firstPin';
  static const _storedPin = 'storedPin';

  Future<void> deleteSavedData() async =>
      await _pinCodeRepository.writePinToStorage(_firstPin, null);

  @override
  Future<bool> isPinCodeInSecureStorage() async =>
      await _pinCodeRepository.readPinFromStorage(key: _storedPin) != null;

  Future<bool> checkIsPinCreated() async =>
      await _pinCodeRepository.checkIsPinCreated() != null;

  @override
  Future<String> encryptPinCode(String pinCode) async =>
      md5.convert(utf8.encode(pinCode)).toString();

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    final firstPin =
        await _pinCodeRepository.readPinFromStorage(key: _firstPin);
    if (firstPin == null) {
      await _pinCodeRepository.writePinToStorage(_firstPin, pinCode);
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
