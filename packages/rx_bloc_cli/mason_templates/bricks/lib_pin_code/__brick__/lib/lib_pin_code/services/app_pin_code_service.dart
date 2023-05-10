{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

/// You have to implement and provide a [PinCodeService], you can use this to
/// store the value of [_pinCode], for example in [SharedPreferences]
class AppPinCodeService implements PinCodeService {
  AppPinCodeService();

  /// This pin is intended to be stored in the secured storage for production
  /// applications
  String? _pinCode;

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    if (_pinCode == null) {
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Future<String> encryptPinCode(String pinCode) async {
    _pinCode = pinCode;
    return Future.value(pinCode);
  }

  @override
  Future<int> getPinLength() async => Future.value(3);

  @override
  Future<bool> verifyPinCode(String pinCode) {
    if (pinCode == '111') {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<String?> getPinCode() async {
    if (_pinCode == null) {
      return Future.value(null);
    }
    return Future.value(_pinCode);
  }
}