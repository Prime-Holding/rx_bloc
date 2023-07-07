{{> licence.dart }}

class RoutesPath {
  static const dashboard = '/dashboard';{{#enable_feature_profile}}
  static const profile = '/profile';{{/enable_feature_profile}}
  static const splash = '/splash';{{#enable_feature_counter}}
  static const counter = '/counter';{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  static const widgetToolkit = '/widget-toolkit';{{/enable_feature_widget_toolkit}}{{#enable_feature_otp}}
  static const otpRoute = '/otp-screen';{{/enable_feature_otp}}{{#enable_feature_profile}}
  static const notifications = 'notifications';{{/enable_feature_profile}}
  static const login = '/login';{{#enable_feature_deeplinks}}
  static const enterMessage = 'enterMessage';
  static const deepLinks = '/deepLinks';
  static const deepLinkDetails = ':id';{{/enable_feature_deeplinks}}
}
