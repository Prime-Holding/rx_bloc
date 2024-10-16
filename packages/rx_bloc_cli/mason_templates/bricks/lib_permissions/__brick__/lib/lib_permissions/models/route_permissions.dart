{{> licence.dart }}

class RoutePermissions { {{#enable_mfa}}
  static const mfa = 'MfaRoute';{{/enable_mfa}}
  static const dashboard = 'DashboardRoute';{{#enable_profile}}
  static const profile = 'ProfileRoute';{{/enable_profile}}
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
