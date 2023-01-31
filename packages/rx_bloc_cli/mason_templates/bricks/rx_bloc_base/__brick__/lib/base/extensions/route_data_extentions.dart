{{> licence.dart }}

import '../../app_extensions.dart';
import '../routers/router.dart';

extension RouteDataX on GoRouteData {
  String getPermissionName() {
    switch (this) {
      case SplashRoute():
        return const SplashRoute().permissionName;
      case CounterRoute():
        return const CounterRoute().permissionName;
      case LoginRoute():
        return const LoginRoute().permissionName;
      case NotificationsRoute():
        return const NotificationsRoute().permissionName;
      default:
        return const SplashRoute().permissionName;
    }
  }
}
