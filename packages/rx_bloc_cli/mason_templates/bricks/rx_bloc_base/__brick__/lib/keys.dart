import 'package:flutter/foundation.dart';

typedef K = Keys;

class Keys {
  const Keys();
  {{#enable_login}}
  static const loginButton = Key('loginButton');
  static const loginEmail = Key('loginEmail');
  static const loginPassword = Key('loginPassword');{{/enable_login}}
  static const bottomNavigationBar = Key('bottomNavigationBar');
  {{#enable_feature_counter}}
  static const counterCount = Key('counterCount');
  static const counterIncrement = Key('counterIncrement');
  static const appLoadingIndicatorIncrement =
      Key('appLoadingIndicatorIncrement');
  static const counterDecrement = Key('counterDecrement');
  static const appLoadingIndicatorDecrement =
      Key('appLoadingIndicatorDecrement');
  static const counterReload = Key('counterReload');
  static const counterError = Key('counterErrorKey');
{{/enable_feature_counter}}
  {{#enable_feature_otp}}
  static const otpInput = Key('otpInputKey');
  {{/enable_feature_otp}}
}
