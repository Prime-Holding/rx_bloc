{{> licence.dart }}

class RoutesPath {
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const splash = '/splash';
  {{#enable_feature_counter}}
  static const counter = '/counter';
  {{/enable_feature_counter}}
  static const notifications = 'notifications';
  static const login = '/login';
  {{#enable_feature_deeplinks}}
  static const enterMessage = 'enterMessage';
  static const deepLinks = '/deepLinks';
  static const deepLinkDetails = ':id';
  {{/enable_feature_deeplinks}}
}
