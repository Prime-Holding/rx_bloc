{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';

/// You have to implement and provide a [PinCodeService], you can use this to
/// store the value of [_pinCode], for example in [SharedPreferences]
class AppPinCodeService implements PinCodeService {
  AppPinCodeService({
    required this.sharedPreferences,
    required this.storage,
  });

  final SharedPreferencesInstance sharedPreferences;
  final FlutterSecureStorage storage;

  /// This pin is intended to be stored in the secured storage for production
  /// applications
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
    await storage.write(key: _storedPin, value: null);
    await storage.write(key: _firstPin, value: null);
    await storage.write(key: _secondPin, value: null);
    await sharedPreferences.setBool(_isForFirstTime, true);
    await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = true;
    _isChangePin = false;
  }

  Future<void> deleteSavedData() async {
    var enabledFromBefore = await sharedPreferences
        .getString(_areBiometricsEnabledWhileUsingTheApp);
    var current = await sharedPreferences.getBool(_areBiometricsEnabled);
    if ((enabledFromBefore == 'true' && current != true)) {
      await sharedPreferences.setString(
          _areBiometricsEnabledWhileUsingTheApp, current.toString());
    } else if ((enabledFromBefore == 'false' && current != false)) {
      await sharedPreferences.setString(
          _areBiometricsEnabledWhileUsingTheApp, current.toString());
    }
    await storage.write(key: _firstPin, value: null);
    await storage.write(key: _secondPin, value: null);
    await sharedPreferences.setBool(_isForFirstTime, true);
    await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
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
        await sharedPreferences.getBool(_isAuthenticatedWithBiometrics);
    if (isAuthenticateWithBiometrics == true) {
      await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
      return false;
    }
    var storedPin = await storage.read(key: _storedPin);
    if (storedPin != null) {
      return true;
    }
    var isFirst = await sharedPreferences.getBool(_isForFirstTime); //
    isFirst = isFirst ?? true;
    var firstPin = await storage.read(key: _firstPin);
    if (isFirst && firstPin == null && !_isForFirstTimeExecuted) {
      await sharedPreferences.setBool(_isForFirstTime, true);
      _isForFirstTimeExecuted = true;
      return false;
    }
    return false;
  }

  Future<bool> checkIsPinCreated() async {
    var storedPin = await storage.read(key: _storedPin);
    if (storedPin != null) {
      return true;
    }
    return false;
  }

  @override
  Future<String> encryptPinCode(String pinCode) async {
    return pinCode;
  }

  @override
  Future<int> getPinLength() async => 3;

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    var currentPin = await storage.read(key: _storedPin);
    final isAuthenticated =
        await sharedPreferences.getBool(_isAuthenticatedWithBiometrics);
    if (currentPin == null) {
// Create Pin process
      final isFirst = await sharedPreferences.getBool(_isForFirstTime) ?? false;
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
          var first = await storage.read(key: _firstPin);
          if (first == null) {
            await storage.write(key: _secondPin, value: null);
            await sharedPreferences.setBool(_isForFirstTime, true);
            _isChangePin = true;
            await sharedPreferences.setString(
                _areBiometricsEnabledWhileUsingTheApp, 'false');
          }
        }
      }
      final firstPin = await storage.read(key: _firstPin);
      if (firstPin != null) {
        if (pinCode == firstPin) {
          await storage.write(key: _secondPin, value: pinCode);
          await storage.write(key: _storedPin, value: pinCode);
          _isChangePin = false;
          await sharedPreferences.setBool(
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
        var isFirst = await sharedPreferences.getBool(_isForFirstTime);
        isFirst = isFirst ?? true;
        if (isFirst) {
          await sharedPreferences.setBool(_isForFirstTime, false);
          await storage.write(key: _firstPin, value: pinCode);
          return true;
        }
        final firstPin = await storage.read(key: _firstPin);
        if (pinCode == firstPin) {
          await storage.write(key: _secondPin, value: pinCode);
          await storage.write(key: _storedPin, value: pinCode);
          await sharedPreferences.setBool(
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
        await sharedPreferences.setBool(_isForFirstTime, false);
        await storage.write(key: _firstPin, value: pinCode);
        return true;
      }
      final firstPin = await storage.read(key: _firstPin);
      if (pinCode == firstPin) {
        await storage.write(key: _secondPin, value: pinCode);
        await storage.write(key: _storedPin, value: pinCode);
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
  Future<String?> getPinCode() async {
    var currentPin = await storage.read(key: _storedPin);
    return currentPin;
  }
}
