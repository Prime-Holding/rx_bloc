{{> licence.dart }}

class RoutesPath {
  static const splash = '/';

  {{#has_authentication}}
  /// Login and Onboarding
  static const login = '/login'; {{#enable_feature_onboarding}}
  static const onboarding = 'onboarding';
  static const onboardingEmailConfirmation = 'email-confirmation';
  static const onboardingEmailConfirmed = '/onboarding/email-confirmed/:token';

  static const onboardingPhone = 'phone';
  static const onboardingPhoneConfirm = 'confirm';

  static const phoneChange = '/change-phone';
  static const phoneChangeConfirm = 'confirm';
  {{/enable_feature_onboarding}}{{/has_authentication}}

  {{#enable_forgotten_password}}
  /// Password Reset
  static const passwordResetRequest = '/request-password-reset';
  static const passwordResetConfirmation = 'confirm';
  static const passwordReset = '/password-reset';
  {{/enable_forgotten_password}}

  /// Dashboard
  static const dashboard = '/dashboard';

  {{#has_showcase}}
  /// Showcases
  static const showcase = '/showcase'; {{/has_showcase}}{{#enable_feature_counter}}
  static const counter = 'counter';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'widget-toolkit';{{/enable_feature_widget_toolkit}}
  static const notifications = 'notifications';{{#enable_feature_otp}}
  static const showcaseOtp = 'otp';{{/enable_feature_otp}}{{#enable_feature_qr_scanner}}
  static const qrCode = 'qrCode';{{/enable_feature_qr_scanner}}{{#enable_mfa}}

  static const mfa = 'mfa';
  static const mfaPinBiometrics = '/showcase/mfa/pin-biometrics/:transactionId';
  static const mfaOtp = '/showcase/mfa/otp/:transactionId';{{/enable_mfa}}{{#enable_feature_deeplinks}}

  /// Deep Links
  static const enterMessage = 'enterMessage';
  static const deepLinks = 'deepLinks';
  static const deepLinkDetails = ':id';{{/enable_feature_deeplinks}}

  {{#enable_profile}}
  /// Profile
  static const profile = '/profile';{{/enable_profile}}

  {{#enable_pin_code}}
  /// Pin Code
  static const verifyPinCode = '/verifyPinCode';
  static const setPinCode = '/profile/setPinCode';
  static const confirmPinCode = '/profile/confirmPinCode';
  static const updatePinCode = '/profile/updatePinCode';{{/enable_pin_code}}

  {{#enable_feature_otp}}
  /// OTP
  static const otpRoute = '/otp-screen';{{/enable_feature_otp}}

  {{#enable_feature_onboarding}}
  /// Change email
  static const emailChange = 'change-email';
  static const emailChangeConfirm = '/change-email/email-confirmation';
  static const emailChangeConfirmed = '/change-email/email-confirmed/:token';{{/enable_feature_onboarding}}

}
