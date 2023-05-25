{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../models/pin_code_data.dart';

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
  String? _pinCode;
  final _isForFirstTime = 'isForFirstTime';

  final _firstPin = 'firstPin';
  final _secondPin = 'secondPin';

  Future<PinCodeData> setIsPinCreated(bool isPinCreated) async {
    if (!isPinCreated) {
      await sharedPreferences.setBool(_isForFirstTime, true);
      await storage.write(key: _firstPin, value: null);
      await storage.write(key: _secondPin, value: null);
    }

    return PinCodeData(isPinCodeCreated: isPinCreated, isPinCodeUpdated: false);
  }

  Future<void> _deleteSavedData() async {
    await storage.write(key: _firstPin, value: null);
    await storage.write(key: _secondPin, value: null);
    await sharedPreferences.setBool(_isForFirstTime, true);
  }

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    final second = await storage.read(key: _secondPin);
    var isFirst = await sharedPreferences.getBool(_isForFirstTime); //
    isFirst = isFirst ?? true;
    var firstPin = await storage.read(key: _firstPin);
    if (isFirst && firstPin == null) {
      await sharedPreferences.setBool(_isForFirstTime, true);
      return false;
    }

    if (second == null) {
      return false;
    }

    return false;
  }

  @override
  Future<String> encryptPinCode(String pinCode) async {
    _pinCode = pinCode;
    return pinCode;
  }

  @override
  Future<int> getPinLength() async => 3;

  @override
  Future<bool> verifyPinCode(String pinCode) async {
    final isFirst = await sharedPreferences.getBool(_isForFirstTime) ?? false;
    if (pinCode.length == await getPinLength()) {
      if (isFirst) {
        await sharedPreferences.setBool(_isForFirstTime, false);
        await storage.write(key: _firstPin, value: pinCode);
        return false;
      }
      final firstPin = await storage.read(key: _firstPin);

      if (pinCode == firstPin) {
        await storage.write(key: _secondPin, value: pinCode);

        return true;
      }

      if (!isFirst) {
        await _deleteSavedData();
        throw ErrorWrongPin(errorMessage: 'Wrong Pin');
      }
      return false;
    }

    return false;
  }

  @override
  Future<String?> getPinCode() async {
    if (_pinCode == null) {
      return null;
    }
    return _pinCode;
  }
}
