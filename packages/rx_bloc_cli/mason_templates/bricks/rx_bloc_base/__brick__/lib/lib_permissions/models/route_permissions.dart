{{> licence.dart }}

class RoutePermissions {
  static const profile = 'ProfileRoute';
  static const splash = 'SplashRoute';
  {{#enable_feature_counter}}
  static const counter = 'CounterRoute';
  {{/enable_feature_counter}}
  static const notifications = 'NotificationRoute';
  static const login = 'LoginRoute';
  static const enterMessage = 'EnterMessageRoute';
  static const deepLinks = 'DeepLinksRoute';
  static const deepLinkDetails = 'DeepLinkDetailsRoute';
}
