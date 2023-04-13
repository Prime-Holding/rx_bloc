import 'package:flutter/foundation.dart';

typedef K = Keys;

class Keys {
  const Keys();

  static const loginButtonKey = Key('loginButtonKey');
  static const loginEmailKey = Key('loginEmailKey');
  static const loginPasswordKey = Key('loginPasswordKey');  
  static const bottomNavigationBarKey = Key('bottomNavigationBarKey');
{{#enable_feature_counter}}
  static const counterCountKey = Key('counterCountKey');
  static const counterIncrementKey = Key('counterIncrementKey');
  static const appLoadingIndicatorIncrementKey =
      Key('appLoadingIndicatorIncrementKey');
  static const counterDecrementKey = Key('counterDecrementKey');
  static const appLoadingIndicatorDecrementKey =
      Key('appLoadingIndicatorDecrementKey');
  static const counterReloadKey = Key('counterReloadKey');

  static const counterErrorKey = Key('counterErrorKey');
{{/enable_feature_counter}}
}
