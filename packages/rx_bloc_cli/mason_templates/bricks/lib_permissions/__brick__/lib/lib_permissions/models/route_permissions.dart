{{> licence.dart }}

class RoutePermissions {
  static const dashboard = 'DashboardRoute';{{#enable_feature_profile}}
  static const profile = 'ProfileRoute';{{/enable_feature_profile}}
  static const splash = 'SplashRoute';{{#enable_feature_counter}}
  static const counter = 'CounterRoute';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'WidgetToolkitRoute';{{/enable_feature_widget_toolkit}}{{#enable_feature_profile}}
  static const notifications = 'NotificationsRoute';{{/enable_feature_profile}}
  static const login = 'LoginRoute';{{#enable_feature_deeplinks}}
  static const enterMessage = 'EnterMessageRoute';
  static const deepLinks = 'DeepLinksRoute';
  static const deepLinkDetails = 'DeepLinkDetailsRoute';{{/enable_feature_deeplinks}}
}
