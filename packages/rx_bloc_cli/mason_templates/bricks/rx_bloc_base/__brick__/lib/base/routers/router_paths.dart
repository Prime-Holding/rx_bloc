{{> licence.dart }}

import 'permission_names.dart';

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
        return PermissionNames.splashPage;
      case counter:
        return PermissionNames.counterPage;
      case notifications:
        return PermissionNames.notificationsPage;
      case login:
        return PermissionNames.loginPage;
      case enterMessage:
        return PermissionNames.enterMessagePage;
      case items:
        return PermissionNames.itemsPage;
      case itemDetails:
        return PermissionNames.itemDetailsPage;
      default:
        return PermissionNames.counterPage;
    }
  }
}
