{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';

class PinCodeDataSource {
  PinCodeDataSource(
    this._sharedPreferences,
    this._storage,
  );

  final SharedPreferencesInstance _sharedPreferences;
  final FlutterSecureStorage _storage;

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
    await _storage.write(key: _storedPin, value: null);
    await _storage.write(key: _firstPin, value: null);
    await _storage.write(key: _secondPin, value: null);
    await _sharedPreferences.setBool(_isForFirstTime, true);
    await _sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = true;
    _isChangePin = false;
  }

  Future<void> deleteSavedData() async {
  var enabledFromBefore =
  await _sharedPreferences.getBool(_areBiometricsEnabledWhileUsingTheApp);
  var current = await _sharedPreferences.getBool(_areBiometricsEnabled);

  if (current != null) {
    if ((enabledFromBefore == true && current != true)) {
      await _sharedPreferences.setBool(
      _areBiometricsEnabledWhileUsingTheApp, current);
    } else if ((enabledFromBefore == false && current != false)) {
      await _sharedPreferences.setBool(
      _areBiometricsEnabledWhileUsingTheApp, current);
    }
  } else {
    await _sharedPreferences.remove(_areBiometricsEnabledWhileUsingTheApp);
  }

    await _storage.write(key: _firstPin, value: null);
    await _storage.write(key: _secondPin, value: null);
    await _sharedPreferences.setBool(_isForFirstTime, true);
    await _sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = true;
    _isChangePin = false;
  }

  Future<bool> setPinCodeType(bool isFromSessionTimeout) async {
    _isFromSessionTimeout = isFromSessionTimeout;
    return isFromSessionTimeout;
  }

  Future<bool> isPinCodeInSecureStorage() async {
    final isAuthenticateWithBiometrics =
        await _sharedPreferences.getBool(_isAuthenticatedWithBiometrics);
    if (isAuthenticateWithBiometrics == true) {
      await _sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
      return false;
    }
    final storedPin = await _storage.read(key: _storedPin);
    if (storedPin != null) {
      return true;
    }
    final isFirst = await _sharedPreferences.getBool(_isForFirstTime) ?? true;
    final firstPin = await _storage.read(key: _firstPin);
    if (isFirst && firstPin == null && !_isForFirstTimeExecuted) {
      await _sharedPreferences.setBool(_isForFirstTime, true);
      _isForFirstTimeExecuted = true;
      return false;
    }
    return false;
  }

  Future<bool> checkIsPinCreated() async {
    final storedPin = await _storage.read(key: _storedPin);
    if (storedPin != null) {
      return true;
    }
    return false;
  }

  Future<String> encryptPinCode(String pinCode) async {
    return pinCode;
  }

  Future<int> getPinLength() async => 3;

  Future<bool> verifyPinCode(String pinCode) async {
    final currentPin = await _storage.read(key: _storedPin);
    final isAuthenticated =
        await _sharedPreferences.getBool(_isAuthenticatedWithBiometrics);
    if (currentPin == null) {
      // Create Pin process
      final isFirst =
          await _sharedPreferences.getBool(_isForFirstTime) ?? false;
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
          final first = await _storage.read(key: _firstPin);
          if (first == null) {
            await _storage.write(key: _secondPin, value: null);
            await _sharedPreferences.setBool(_isForFirstTime, true);
            _isChangePin = true;
            await _sharedPreferences.setBool(
                _areBiometricsEnabledWhileUsingTheApp, false);
          }
        }
      }
      final firstPin = await _storage.read(key: _firstPin);
      if (firstPin != null) {
        if (pinCode == firstPin) {
          await _storage.write(key: _secondPin, value: pinCode);
          await _storage.write(key: _storedPin, value: pinCode);
          _isChangePin = false;
          await _sharedPreferences.setBool(
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
        final isFirst = await _sharedPreferences.getBool(_isForFirstTime)
          ?? true;
        if (isFirst) {
          await _sharedPreferences.setBool(_isForFirstTime, false);
          await _storage.write(key: _firstPin, value: pinCode);
          return true;
        }
        final firstPin = await _storage.read(key: _firstPin);
        if (pinCode == firstPin) {
          await _storage.write(key: _secondPin, value: pinCode);
          await _storage.write(key: _storedPin, value: pinCode);
          await _sharedPreferences.setBool(
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
        await _sharedPreferences.setBool(_isForFirstTime, false);
        await _storage.write(key: _firstPin, value: pinCode);
        return true;
      }
      final firstPin = await _storage.read(key: _firstPin);
      if (pinCode == firstPin) {
        await _storage.write(key: _secondPin, value: pinCode);
        await _storage.write(key: _storedPin, value: pinCode);
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

  Future<String?> getPinCode() async => await _storage.read(key: _storedPin);
}
