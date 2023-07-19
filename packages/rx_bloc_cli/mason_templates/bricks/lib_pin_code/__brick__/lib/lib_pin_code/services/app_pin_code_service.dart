{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../repository/pin_code_repository.dart';

class AppPinCodeService implements PinCodeService {
  AppPinCodeService(
    this._pinCodeRepository,
  );

  final PinCodeRepository _pinCodeRepository;

  static const _isForFirstTime = 'isForFirstTime';
  static const _firstPin = 'firstPin';
  static const _secondPin = 'secondPin';
  static const _storedPin = 'storedPin';
  static const _isAuthenticatedWithBiometrics = 'isAuthenticatedWithBiometrics';
  static const _areBiometricsEnabled = 'areBiometricsEnabled';
  static const _areBiometricsEnabledWhileUsingTheApp =
      'areBiometricsEnabledWhileUsingTheApp';
  bool _isForFirstTimeExecuted = false;
  bool _isVerificationPinProcess = true;
  bool _isChangePin = false;
  bool _isFromSessionTimeout = false;
  bool? _isVerificationPinCorrect;

  Future<void> deleteStoredPin() async {
    await _pinCodeRepository.writePinToStorage(key: _storedPin, value: null);
    await _pinCodeRepository.writePinToStorage(key: _firstPin, value: null);
    await _pinCodeRepository.writePinToStorage(key: _secondPin, value: null);

    await _pinCodeRepository.setBoolValue(_isForFirstTime, true);
    await _pinCodeRepository.setBoolValue(
        _isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = true;
    _isChangePin = false;
  }

  Future<void> deleteSavedData() async {
    var enabledFromBefore = await _pinCodeRepository
        .getBoolValue(_areBiometricsEnabledWhileUsingTheApp);
    var current = await _pinCodeRepository.getBoolValue(_areBiometricsEnabled);

    if (current != null) {
      if ((enabledFromBefore == true && current != true)) {
        await _pinCodeRepository.setBoolValue(
            _areBiometricsEnabledWhileUsingTheApp, current);
      } else if ((enabledFromBefore == false && current != false)) {
        await _pinCodeRepository.setBoolValue(
            _areBiometricsEnabledWhileUsingTheApp, current);
      }
    } else {
      await _pinCodeRepository
          .removeBoolValue(_areBiometricsEnabledWhileUsingTheApp);
    }

    await _pinCodeRepository.writePinToStorage(key: _firstPin, value: null);
    await _pinCodeRepository.writePinToStorage(key: _secondPin, value: null);
    await _pinCodeRepository.setBoolValue(_isForFirstTime, true);
    await _pinCodeRepository.setBoolValue(
        _isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = true;
    _isChangePin = false;
  }

  Future<bool> setPinCodeType(bool isFromSessionTimeout) async {
    _isFromSessionTimeout = isFromSessionTimeout;
    return isFromSessionTimeout;
  }

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    final isAuthenticateWithBiometrics =
        await _pinCodeRepository.getBoolValue(_isAuthenticatedWithBiometrics);
    if (isAuthenticateWithBiometrics == true) {
      await _pinCodeRepository.setBoolValue(
          _isAuthenticatedWithBiometrics, false);
      return false;
    }
    var storedPin =
        await _pinCodeRepository.readPinFromStorage(key: _storedPin);
    if (storedPin != null) {
      return true;
    }
    var isFirst = await _pinCodeRepository.getBoolValue(_isForFirstTime); //
    isFirst = isFirst ?? true;
    var firstPin = await _pinCodeRepository.readPinFromStorage(key: _firstPin);
    if (isFirst && firstPin == null && !_isForFirstTimeExecuted) {
      await _pinCodeRepository.setBoolValue(_isForFirstTime, true);
      _isForFirstTimeExecuted = true;
      return false;
    }
    return false;
  }

  Future<bool> checkIsPinCreated() async {
    final storedPin = await _pinCodeRepository.checkIsPinCreated();
    if (storedPin != null) {
      return true;
    }
    return false;
  }

  @override
  Future<String> encryptPinCode(String pinCode) =>
      _pinCodeRepository.encryptPinCode(pinCode);

  @override
  Future<int> getPinLength() => _pinCodeRepository.getPinLength();

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    var currentPin =
        await _pinCodeRepository.readPinFromStorage(key: _storedPin);
    final isAuthenticated =
        await _pinCodeRepository.getBoolValue(_isAuthenticatedWithBiometrics);
    if (currentPin == null) {
// Create Pin process
      final isFirst =
          await _pinCodeRepository.getBoolValue(_isForFirstTime) ?? false;
      return await _createPin(pinCode, isFirst);
    } else {
      if (_isFromSessionTimeout) {
// Verify Pin From Inactivity
        return currentPin == pinCode
            ? true
            : throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
      }
// Update pin process
      if (isAuthenticated != true) {
        if (_isVerificationPinCorrect == null) {
          var first =
              await _pinCodeRepository.readPinFromStorage(key: _firstPin);
          if (first == null) {
            await _pinCodeRepository.writePinToStorage(
                key: _secondPin, value: null);
            await _pinCodeRepository.setBoolValue(_isForFirstTime, true);
            _isChangePin = true;
            await _pinCodeRepository.setBoolValue(
                _areBiometricsEnabledWhileUsingTheApp, false);
          }
        }
      }
      final firstPin =
          await _pinCodeRepository.readPinFromStorage(key: _firstPin);
      if (firstPin != null) {
        if (pinCode == firstPin) {
          await _pinCodeRepository.writePinToStorage(
              key: _secondPin, value: pinCode);
          await _pinCodeRepository.writePinToStorage(
              key: _storedPin, value: pinCode);
          _isChangePin = false;
          await _pinCodeRepository.setBoolValue(
              _isAuthenticatedWithBiometrics, false);
          return true;
        }
        throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
      }
      if (isAuthenticated != true) {
        if (firstPin == null && _isVerificationPinProcess) {
// Verification process - Enter current pin
          if (currentPin == pinCode) {
            _isVerificationPinCorrect = true;
            _isVerificationPinProcess = false;
            return true;
          }
          _isVerificationPinCorrect = false;
          _isVerificationPinProcess = true;
          throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
        }
      }
      if (_isChangePin) {
        var isFirst = await _pinCodeRepository.getBoolValue(_isForFirstTime);
        isFirst = isFirst ?? true;
        if (isFirst) {
          await _pinCodeRepository.setBoolValue(_isForFirstTime, false);
          await _pinCodeRepository.writePinToStorage(
              key: _firstPin, value: pinCode);
          return true;
        }
        final firstPin =
            await _pinCodeRepository.readPinFromStorage(key: _firstPin);
        if (pinCode == firstPin) {
          await _pinCodeRepository.writePinToStorage(
              key: _secondPin, value: pinCode);
          await _pinCodeRepository.writePinToStorage(
              key: _storedPin, value: pinCode);
          await _pinCodeRepository.setBoolValue(
              _isAuthenticatedWithBiometrics, false);
          return true;
        }
        if (!isFirst) {
          await deleteSavedData();
          throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
        }
        return false;
      }
      return false;
    }
  }

  Future<bool> _createPin(String pinCode, bool isFirst) async {
    if (pinCode.length == await getPinLength()) {
      if (isFirst) {
        await _pinCodeRepository.setBoolValue(_isForFirstTime, false);
        await _pinCodeRepository.writePinToStorage(
            key: _firstPin, value: pinCode);
        return true;
      }
      final firstPin =
          await _pinCodeRepository.readPinFromStorage(key: _firstPin);
      if (pinCode == firstPin) {
        await _pinCodeRepository.writePinToStorage(
            key: _secondPin, value: pinCode);
        await _pinCodeRepository.writePinToStorage(
            key: _storedPin, value: pinCode);

        _isForFirstTimeExecuted = false;
        return true;
      }
      if (!isFirst) {
        throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
      }
      return false;
    }
    return false;
  }

  @override
  Future<String?> getPinCode() => _pinCodeRepository.getPinCode();
}
