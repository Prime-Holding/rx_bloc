{{> licence.dart }}

class RoutesPath { {{#enable_auth_matrix}}
  static const authMatrix = '/auth-matrix';
  static const authMatrixPinBiometrics = '/auth-matrix/pin-biometrics/:transactionId';
  static const authMatrixOtp = '/auth-matrix/otp/:transactionId';{{/enable_auth_matrix}}
  static const dashboard = '/dashboard';
  static const profile = '/profile';{{#enable_pin_code}}
  static const verifyPinCode = '/verifyPinCode';
  static const createPin = 'createPin';
  static const updatePin = 'updatePin';{{/enable_pin_code}}
  static const splash = '/splash';{{#enable_feature_counter}}
  static const counter = '/counter';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = '/widget-toolkit';{{/enable_feature_widget_toolkit}}{{#enable_feature_otp}}
  static const otpRoute = '/otp-screen';{{/enable_feature_otp}}
  static const notifications = 'notifications';{{#has_authentication}}
  static const login = '/login';{{/has_authentication}}{{#enable_feature_deeplinks}}
  static const enterMessage = 'enterMessage';
  static const deepLinks = '/deepLinks';
  static const deepLinkDetails = ':id';{{/enable_feature_deeplinks}}
}
