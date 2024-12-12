{{> licence.dart }}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';
import '../../base/models/errors/error_model.dart';
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
  Future<bool> savePinCodeInSecureStorage(String pinCode) async {
    await _pinCodeRepository.writePinToStorage(_storedPin, pinCode);
    return true;
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
      await _pinCodeRepository.createPinCode(pinCode);
      await _pinCodeRepository.writePinToStorage(_storedPin, pinCode);
      return true;
    }
    throw ErrorServerGenericModel(
      message: 'PIN code does not match',
    );
  }

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();
}
