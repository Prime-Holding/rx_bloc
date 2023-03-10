{{> licence.dart }}

class RoutePermissions {
  static const dashboard = 'DashboardRoute';
  static const profile = 'ProfileRoute';
  static const splash = 'SplashRoute';
  {{#enable_feature_counter}}
  static const counter = 'CounterRoute';
  {{/enable_feature_counter}}
  {{#enable_feature_widget_toolkit}}
  static const widgetToolkit = 'WidgetToolkitRoute';
  {{/enable_feature_widget_toolkit}}
  static const notifications = 'NotificationRoute';
  static const login = 'LoginRoute';
  {{#enable_feature_deeplinks}}
  static const enterMessage = 'EnterMessageRoute';
  static const deepLinks = 'DeepLinksRoute';
  static const deepLinkDetails = 'DeepLinkDetailsRoute';
  {{/enable_feature_deeplinks}}
}
