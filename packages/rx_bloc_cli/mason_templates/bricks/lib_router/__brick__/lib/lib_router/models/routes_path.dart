{{> licence.dart }}

class RoutesPath {  {{#enable_feature_onboarding}}
  static const emailChange = '/change-email';
  static const emailChangeConfirm = '/change-email/email-confirmation';
  static const emailChangeConfirmed = '/change-email/email-confirmed/:token'; {{/enable_feature_onboarding}}{{#has_showcase}}
  static const showcase = '/showcase'; {{/has_showcase}} {{#enable_feature_otp}}
  static const showcaseOtp = 'otp';{{/enable_feature_otp}}{{#enable_feature_qr_scanner}}
  static const qrCode = 'qrCode';{{/enable_feature_qr_scanner}} {{#enable_mfa}}
  static const mfa = 'mfa';
  static const mfaPinBiometrics = '/showcase/mfa/pin-biometrics/:transactionId';
  static const mfaOtp = '/showcase/mfa/otp/:transactionId';{{/enable_mfa}}
  static const dashboard = '/dashboard';{{#enable_profile}}
  static const profile = '/profile';{{/enable_profile}}{{#enable_pin_code}}
  static const verifyPinCode = '/verifyPinCode';
  static const setPinCode = '/profile/setPinCode';
  static const confirmPinCode = '/profile/confirmPinCode';
  static const updatePinCode = '/profile/updatePinCode';{{/enable_pin_code}}
  static const splash = '/';{{#enable_feature_counter}}
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
  static const deepLinkDetails = ':id';{{/enable_feature_deeplinks}}{{#enable_feature_onboarding}}
  static const onboardingPhone = '/onboarding/phone';
  static const onboardingPhoneConfirm = '/onboarding/phone/confirm';
  static const phoneChange = '/change-phone';
  static const phoneChangeConfirm = '/change-phone/confirm';{{/enable_feature_onboarding}}{{#enable_forgotten_password}}
  static const passwordResetRequest = '/password-reset/request';
  static const passwordResetConfirmation = '/password-reset/confirmation';
  static const passwordReset = '/password-reset';{{/enable_forgotten_password}}
}
