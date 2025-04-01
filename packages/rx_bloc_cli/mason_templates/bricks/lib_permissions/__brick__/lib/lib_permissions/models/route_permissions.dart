{{> licence.dart }}

class RoutePermissions { {{#has_showcase}}
  static const showcase = 'ShowcaseRoute'; {{/has_showcase}}{{#enable_feature_qr_scanner}}
  static const qrCode = 'QrCodeRoute';{{/enable_feature_qr_scanner}} {{#enable_mfa}}
  static const mfa = 'MfaRoute';
  static const mfaPinBiometrics = 'MfaPinBiometricsRoute';
  static const mfaOtp = 'MfaOtpRoute';{{/enable_mfa}}
  static const dashboard = 'DashboardRoute';{{#enable_profile}}
  static const profile = 'ProfileRoute';{{/enable_profile}}
  static const splash = 'SplashRoute';{{#enable_feature_counter}}
  static const counter = 'CounterRoute';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'WidgetToolkitRoute';{{/enable_feature_widget_toolkit}}
  static const notifications = 'NotificationsRoute';{{#enable_pin_code}}
  static const verifyPinCode = 'VerifyPinCodeRoute';
  static const setPinCode = 'SetPinCodeRoute';
  static const confirmPinCode = 'ConfirmPinCodeRoute';
  static const updatePinCode = 'UpdatePinCodeRoute';{{/enable_pin_code}} {{#enable_feature_otp}}
  static const showcaseOtp = 'OtpRoute';  {{/enable_feature_otp}}
  static const login = 'LoginRoute';{{#enable_feature_onboarding}}
  static const emailChange = 'EmailChangeRoute';
  static const emailChangeConfirmation = 'EmailChangeConfirmationRoute';
  static const emailChangeConfirmed = 'EmailChangeConfirmedRoute';
  static const onboarding = 'OnboardingRoute';
  static const onboardingEmailConfirmation = 'OnboardingEmailConfirmationRoute';
  static const onboardingEmailConfirmed = 'OnboardingEmailConfirmedRoute';{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
  static const enterMessage = 'EnterMessageRoute';
  static const deepLinks = 'DeepLinksRoute';
  static const deepLinkDetails = 'DeepLinkDetailsRoute';{{/enable_feature_deeplinks}}{{#enable_feature_onboarding}}
  static const onboardingPhone = 'OnboardingPhoneRoute';
  static const onboardingPhoneConfirm = 'OnboardingPhoneConfirmRoute';
  static const phoneChange = 'PhoneChangeRoute';
  static const phoneChangeConfirm = 'PhoneChangeConfirmRoute';{{/enable_feature_onboarding}}
}
