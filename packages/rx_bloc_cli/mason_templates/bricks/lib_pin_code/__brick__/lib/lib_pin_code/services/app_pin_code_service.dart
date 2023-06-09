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
  final _isForFirstTime = 'isForFirstTime';
  final _firstPin = 'firstPin';
  final _secondPin = 'secondPin';
  final _storedPin = 'storedPin';
  bool _isForFirstTimeExecuted = false;
  bool? _isVerificationPinCorrect;
  bool _isVerificationPinProcess = false;
  bool _isChangePin = false;
  static const _isAuthenticated = 'isAuthenticated';
  static const _isAuthenticatedWithBiometrics = 'isAuthenticatedWithBiometrics';
  static const _areBiometricsEnabled = 'areBiometricsEnabled';

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    final isAuthenticate = await sharedPreferences.getBool(_isAuthenticated);
    final isAuthenticateWithBiometrics =
        await sharedPreferences.getBool(_isAuthenticatedWithBiometrics);
    if (isAuthenticate == true || isAuthenticateWithBiometrics == true) {
      await sharedPreferences.setBool(_isAuthenticated, false);
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

  Future<void> _deleteSavedPinCodes() async {
    await storage.write(key: _firstPin, value: null);
    await storage.write(key: _secondPin, value: null);
    await sharedPreferences.setBool(_isForFirstTime, true);
    await sharedPreferences.setBool(_isAuthenticated, false);
    await sharedPreferences.setBool(_areBiometricsEnabled, true);
    await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
    await storage.write(key: _storedPin, value: null);
  }

  Future<bool> setIsPinCreated(bool? isPinCreated) async {
    if (isPinCreated == null) {
      var storedPin = await storage.read(key: _storedPin);
      if (storedPin != null) {
        return true;
      }
      return false;
    }
    if (!isPinCreated) {
      await _deleteSavedPinCodes();
    }

    return isPinCreated;
  }

  Future<bool> checkIsVerificationPinCorrect(bool? value) async {
    if (_isVerificationPinCorrect == true) {
      _isVerificationPinCorrect = false;
      _isVerificationPinProcess = false;
      _isChangePin = true;
      return true;
    }
    return value ?? false;
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
    if (isAuthenticated == true) {
      // After success biometrics authentication
      _isChangePin = true;
    }
    if (currentPin != null) {
      // Update pin process
      if (isAuthenticated != true) {
        if (_isVerificationPinCorrect == null) {
          if (currentPin != pinCode) {
            throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
          }
          _isVerificationPinProcess = true;
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
          await sharedPreferences.setBool(_isAuthenticated, false);
          return true;
        }

        throw ErrorWrongPin(errorMessage: 'Wrong Confirmation Pin');
      }
      if (isAuthenticated != true) {
        if (firstPin == null && _isVerificationPinProcess) {
          // Verification process
          if (currentPin == pinCode) {
            _isVerificationPinCorrect = true;
            return false;
          }
          _isVerificationPinCorrect = false;
          _isVerificationPinProcess = false;
          return false;
        }
      }
      if (_isChangePin) {
        var isFirst = await sharedPreferences.getBool(_isForFirstTime);
        isFirst = isFirst ?? true;
        if (isFirst) {
          await sharedPreferences.setBool(_isForFirstTime, false);
          await storage.write(key: _firstPin, value: pinCode);
          return false;
        }
        final firstPin = await storage.read(key: _firstPin);
        if (pinCode == firstPin) {
          await storage.write(key: _secondPin, value: pinCode);
          await storage.write(key: _storedPin, value: pinCode);
          await sharedPreferences.setBool(_isAuthenticated, false);
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
      return true;
    }

    // Create Pin process
    var isFirst = await sharedPreferences.getBool(_isForFirstTime);
    isFirst = isFirst ?? false;
    if (pinCode.length == await getPinLength()) {
      if (isFirst) {
        await sharedPreferences.setBool(_isForFirstTime, false);
        await storage.write(key: _firstPin, value: pinCode);
        return false;
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

  Future<void> deleteSavedData() async {
    await storage.write(key: _firstPin, value: null);
    await storage.write(key: _secondPin, value: null);
    await sharedPreferences.setBool(_isForFirstTime, true);
    await sharedPreferences.setBool(_isAuthenticated, false);
    await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, false);
    _isForFirstTimeExecuted = false;
    _isVerificationPinCorrect = null;
    _isVerificationPinProcess = false;
    _isChangePin = false;
  }
}
