{{> licence.dart }}

class RoutesPath {  {{#has_showcase}}
  static const showcase = '/showcase'; {{/has_showcase}} {{#enable_feature_otp}}
  static const showcaseOtp = 'otp';{{/enable_feature_otp}}{{#enable_feature_qr_scanner}}
  static const qrCode = 'qrCode';{{/enable_feature_qr_scanner}} {{#enable_mfa}}
  static const mfa = 'mfa';
  static const mfaPinBiometrics = '/mfa/pin-biometrics/:transactionId';
  static const mfaOtp = '/mfa/otp/:transactionId';{{/enable_mfa}}
  static const dashboard = '/dashboard';{{#enable_profile}}
  static const profile = '/profile';{{/enable_profile}}{{#enable_pin_code}}
  static const verifyPinCode = '/verifyPinCode';
  static const createPin = 'createPin';
  static const updatePin = 'updatePin';{{/enable_pin_code}}
  static const splash = '/splash';{{#enable_feature_counter}}
  static const counter = 'counter';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'widget-toolkit';{{/enable_feature_widget_toolkit}}{{#enable_feature_otp}}
  static const otpRoute = '/otp-screen';{{/enable_feature_otp}}
  static const notifications = 'notifications';{{#has_authentication}}
  static const login = '/login';{{/has_authentication}}{{#enable_feature_onboarding}}
  static const onboarding = '/onboarding';
  static const onboardingEmailConfirmation = '/onboarding/email-confirmation';
  static const onboardingEmailConfirmed = '/onboarding/email-confirmed/:token';{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
  static const enterMessage = 'enterMessage';
  static const deepLinks = 'deepLinks';
  static const deepLinkDetails = ':id';{{/enable_feature_deeplinks}}
}
