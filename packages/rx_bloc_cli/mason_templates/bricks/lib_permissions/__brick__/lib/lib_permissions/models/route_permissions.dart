{{> licence.dart }}

class RoutePermissions { {{#enable_feature_qr_scanner}}
  static const qrCode = 'QrCodeRoute';{{/enable_feature_qr_scanner}} {{#enable_mfa}}
  static const mfa = 'MfaRoute';{{/enable_mfa}}
  static const dashboard = 'DashboardRoute';
  static const profile = 'ProfileRoute';
  static const splash = 'SplashRoute';{{#enable_feature_counter}}
  static const counter = 'CounterRoute';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'WidgetToolkitRoute';{{/enable_feature_widget_toolkit}}
  static const notifications = 'NotificationsRoute';{{#enable_pin_code}}
  static const pinCode = 'VerifyPinCode';{{/enable_pin_code}}
  static const login = 'LoginRoute';{{#enable_feature_deeplinks}}
  static const enterMessage = 'EnterMessageRoute';
  static const deepLinks = 'DeepLinksRoute';
  static const deepLinkDetails = 'DeepLinkDetailsRoute';{{/enable_feature_deeplinks}}
}
