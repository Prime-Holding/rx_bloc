{{> licence.dart }}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

/// You have to implement and provide a [PinCodeService], you can use this to
/// store the value of [_pinCode], for example in [SharedPreferences]
/// TODO copy this file
class AppPinCodeService implements PinCodeService {
  AppPinCodeService();

  Future<SharedPreferences> get _storageInstance =>
      SharedPreferences.getInstance();

  /// This pin is intended to be stored in the secured storage for production
  /// applications
  String? _pinCode;
  final _isForFirstTime = 'isForFirstTime';

  final _firstPin = 'firstPin';
  final _secondPin = 'secondPin';

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    final storage = await _storageInstance;
    final second = storage.getString(_secondPin);
    var isFirst = storage.getBool(_isForFirstTime);
    isFirst = isFirst ?? true;
    var firstPin = storage.getString(_firstPin);
    if (isFirst && firstPin == null) {
      await storage.setBool(_isForFirstTime, true);
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
    final storage = await _storageInstance;
    final isFirst = storage.getBool(_isForFirstTime) ?? false;
    if (pinCode.length == await getPinLength()) {
      if (isFirst) {
        await storage.setBool(_isForFirstTime, false);
        await storage.setString(_firstPin, pinCode);
        return false;
      }
      final firstPin = storage.getString(_firstPin);

      if (pinCode == firstPin) {
        await storage.setString(_secondPin, pinCode);

        return true;
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
