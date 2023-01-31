{{> licence.dart }}

import 'router_permission_names.dart';

abstract class RouterPaths {
  static const String splash = '/splash';
  static const String counter = '/';
  static const String notifications = '/notifications';
  static const String login = '/login';
  static const String enterMessage = '/enterMessage';
  static const String items = '/items';
  static const String itemDetails = '/items/:id';

  static String pathToRouteName(String path) {
    switch (path) {
      case splash:
        return RouterPermissionNames.splashPage;
      case counter:
        return RouterPermissionNames.counterPage;
      case notifications:
        return RouterPermissionNames.notificationsPage;
      case login:
        return RouterPermissionNames.loginPage;
      case enterMessage:
        return RouterPermissionNames.enterMessagePage;
      case items:
        return RouterPermissionNames.itemsPage;
      case itemDetails:
        return RouterPermissionNames.itemDetailsPage;
      default:
        return RouterPermissionNames.counterPage;
    }
  }
}
