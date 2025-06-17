{{> licence.dart }}

import '../../lib_permissions/models/route_permissions.dart';
import 'routes_path.dart';

enum RouteModel {
  /// Splash is the initial route of the app so the full path is '/'
  splash(
    pathName: RoutesPath.splash,
    fullPath: '/',
    permissionName: RoutePermissions.splash,
  ),

  {{#has_authentication}}
  /// Login and Onboarding
  login(
    pathName: RoutesPath.login,
    fullPath: '/login',
    permissionName: RoutePermissions.login,
  ),{{#enable_feature_onboarding}}
  onboarding(
    pathName: RoutesPath.onboarding,
    fullPath: '/login/onboarding',
    permissionName: RoutePermissions.onboarding,
  ),
  onboardingEmailConfirmation(
    pathName: RoutesPath.onboardingEmailConfirmation,
    fullPath: '/login/onboarding/email-confirmation',
    permissionName: RoutePermissions.onboardingEmailConfirmation,
  ),
  onboardingEmailConfirmed(
    pathName: RoutesPath.onboardingEmailConfirmed,
    fullPath: '/onboarding/email-confirmed/:token',
    permissionName: RoutePermissions.onboardingEmailConfirmed,
  ),

  onboardingPhone(
    pathName: RoutesPath.onboardingPhone,
    fullPath: '/login/onboarding/phone',
    permissionName: RoutePermissions.onboardingPhone,
  ),
  onboardingPhoneConfirm(
    pathName: RoutesPath.onboardingPhoneConfirm,
    fullPath: '/login/onboarding/phone/confirm',
    permissionName: RoutePermissions.onboardingPhoneConfirm,
  ),

  phoneChange(
    pathName: RoutesPath.phoneChange,
    fullPath: '/change-phone',
    permissionName: RoutePermissions.phoneChange,
  ),
  phoneChangeConfirm(
    pathName: RoutesPath.phoneChangeConfirm,
    fullPath: '/change-phone/confirm',
    permissionName: RoutePermissions.phoneChangeConfirm,
  ),{{/enable_feature_onboarding}}{{/has_authentication}}

  {{#enable_forgotten_password}}
  /// Password Reset
  passwordResetRequest(
    pathName: RoutesPath.passwordResetRequest,
    fullPath: '/login/request-password-reset',
    permissionName: RoutePermissions.passwordResetRequest,
  ),
  passwordResetConfirmation(
    pathName: RoutesPath.passwordResetConfirmation,
    fullPath: '/login/request-password-reset/confirm',
    permissionName: RoutePermissions.passwordResetConfirmation,
  ),
  passwordReset(
    pathName: RoutesPath.passwordReset,
    fullPath: '/login/password-reset',
    permissionName: RoutePermissions.passwordReset,
  ),{{/enable_forgotten_password}}

  /// Dashboard
  dashboard(
    pathName: RoutesPath.dashboard,
    fullPath: '/dashboard',
    permissionName: RoutePermissions.dashboard,
  ),

  {{#has_showcase}}
  /// Showcases
  showcase(
    pathName: RoutesPath.showcase,
    fullPath: '/showcase',
    permissionName: RoutePermissions.showcase,
  ),{{/has_showcase}}{{#enable_feature_counter}}

  counter(
    pathName: RoutesPath.counter,
    fullPath: '/showcase/counter',
    permissionName: RoutePermissions.counter,
  ),{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  widgetToolkit(
    pathName: RoutesPath.widgetToolkit,
    fullPath: '/showcase/widget-toolkit',
    permissionName: RoutePermissions.widgetToolkit,
  ),{{/enable_feature_widget_toolkit}}
  notifications(
    pathName: RoutesPath.notifications,
    fullPath: '/showcase/notifications',
    permissionName: RoutePermissions.notifications,
  ),{{#enable_feature_otp}}
  showcaseOtp(
    pathName: RoutesPath.showcaseOtp,
    fullPath: '/showcase/otp',
    permissionName: RoutePermissions.showcaseOtp,
  ),{{/enable_feature_otp}}{{#enable_feature_qr_scanner}}
  qrCode(
    pathName: RoutesPath.qrCode,
    fullPath: '/showcase/qrCode',
    permissionName: RoutePermissions.qrCode,
  ),{{/enable_feature_qr_scanner}}{{#enable_mfa}}

  mfa(
    pathName: RoutesPath.mfa,
    fullPath: '/showcase/mfa',
    permissionName: RoutePermissions.mfa,
  ),
  mfaPinBiometrics(
    pathName: RoutesPath.mfaPinBiometrics,
    fullPath: '/showcase/mfa/pin-biometrics/:transactionId',
    permissionName: RoutePermissions.mfaPinBiometrics,
  ),
  mfaOtp(
    pathName: RoutesPath.mfaOtp,
    fullPath: '/showcase/mfa/otp/:transactionId',
    permissionName: RoutePermissions.mfaOtp,
  ),{{/enable_mfa}}{{#enable_feature_deeplinks}}

  /// Deep Links
  enterMessage(
    pathName: RoutesPath.enterMessage,
    fullPath: '/showcase/enterMessage',
    permissionName: RoutePermissions.enterMessage,
  ),
  deepLinks(
    pathName: RoutesPath.deepLinks,
    fullPath: '/showcase/deepLinks',
    permissionName: RoutePermissions.deepLinks,
  ),
  deepLinkDetails(
    pathName: RoutesPath.deepLinkDetails,
    fullPath: '/showcase/deepLinks/:id',
    permissionName: RoutePermissions.deepLinkDetails,
  ),{{/enable_feature_deeplinks}}

  {{#enable_profile}}
  /// Profile
  profile(
    pathName: RoutesPath.profile,
    fullPath: '/profile',
    permissionName: RoutePermissions.profile,
  ),{{/enable_profile}}

  {{#enable_pin_code}}
  /// Pin Code
  verifyPinCode(
    pathName: RoutesPath.verifyPinCode,
    fullPath: '/verifyPinCode',
    permissionName: RoutePermissions.verifyPinCode,
  ),
  setPinCode(
    pathName: RoutesPath.setPinCode,
    fullPath: '/profile/setPinCode',
    permissionName: RoutePermissions.setPinCode,
  ),
  confirmPinCode(
    pathName: RoutesPath.confirmPinCode,
    fullPath: '/profile/confirmPinCode',
    permissionName: RoutePermissions.confirmPinCode,
  ),
  updatePinCode(
    pathName: RoutesPath.updatePinCode,
    fullPath: '/profile/updatePinCode',
    permissionName: RoutePermissions.updatePinCode,
  ),{{/enable_pin_code}}

  {{#enable_feature_onboarding}}
  /// Change email
  emailChange(
    pathName: RoutesPath.emailChange,
    fullPath: '/profile/email-change',
    permissionName: RoutePermissions.emailChange,
  ),
  emailChangeVerify(
    pathName: RoutesPath.emailChangeVerify,
    fullPath: '/profile/email-change/verify',
    permissionName: RoutePermissions.emailChangeVerify,
  ),
  emailChangeConfirm(
    pathName: RoutesPath.emailChangeConfirm,
    fullPath: '/change-email/email-confirmation',
    permissionName: RoutePermissions.emailChangeConfirmation,
  ),
  emailChangeConfirmed(
    pathName: RoutesPath.emailChangeConfirmed,
    fullPath: '/change-email/email-confirmed/:token',
    permissionName: RoutePermissions.emailChangeConfirmed,
  ){{/enable_feature_onboarding}}
  ;

  final String pathName;
  final String fullPath;
  final String permissionName;

  const RouteModel({
    required this.pathName,
    required this.fullPath,
    required this.permissionName,
  });

  static final Map<String, String> nameByPath = {};

  static String? getRouteNameByFullPath(String path) {
    if (nameByPath.isEmpty) {
      for (RouteModel paths in RouteModel.values) {
        nameByPath[paths.fullPath] = paths.permissionName;
      }
    }
    return nameByPath[path];
  }
}