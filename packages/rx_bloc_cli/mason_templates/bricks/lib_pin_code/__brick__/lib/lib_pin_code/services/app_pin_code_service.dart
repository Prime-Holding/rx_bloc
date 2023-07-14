{{> licence.dart }}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../repository/pin_code_repository.dart';

class AppPinCodeService implements PinCodeService {
  AppPinCodeService(
    this._pinCodeRepository,
  );

  final PinCodeRepository _pinCodeRepository;

  Future<void> deleteStoredPin() => _pinCodeRepository.deleteStoredPin();

  Future<void> deleteSavedData() => _pinCodeRepository.deleteSavedData();

  Future<bool> setPinCodeType(bool isFromSessionTimeout) =>
      _pinCodeRepository.setPinCodeType(isFromSessionTimeout);

  @override
  Future<bool> isPinCodeInSecureStorage() =>
      _pinCodeRepository.isPinCodeInSecureStorage();

  Future<bool> checkIsPinCreated() => _pinCodeRepository.checkIsPinCreated();

  @override
  Future<String> encryptPinCode(String pinCode) =>
      _pinCodeRepository.encryptPinCode(pinCode);

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> verifyPinCode(String pinCode) =>
      _pinCodeRepository.verifyPinCode(pinCode);

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();
}
