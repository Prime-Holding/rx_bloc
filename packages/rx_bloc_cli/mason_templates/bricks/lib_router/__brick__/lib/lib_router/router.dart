{{> licence.dart }}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../base/common_blocs/coordinator_bloc.dart';{{#enable_feature_deeplinks}}
import '../base/models/deep_link_model.dart';{{/enable_feature_deeplinks}}{{#enable_feature_counter}}
import '../feature_counter/di/counter_page_with_dependencies.dart';{{/enable_feature_counter}}
import '../feature_dashboard/di/dashboard_page_with_dependencies.dart';{{#enable_feature_deeplinks}}
import '../feature_deep_link_details/di/deep_link_details_page_with_dependencies.dart';
import '../feature_deep_link_list/di/deep_link_list_page_with_dependencies.dart';
import '../feature_enter_message/di/enter_message_with_dependencies.dart';{{/enable_feature_deeplinks}}
import '../feature_home/views/home_page.dart';
import '../feature_login/di/login_page_with_dependencies.dart';{{#enable_feature_profile}}
import '../feature_notifications/di/notifications_page_with_dependencies.dart';{{/enable_feature_profile}}{{#enable_feature_otp}}
import '../feature_otp/di/otp_page_with_dependencies.dart';{{/enable_feature_otp}}{{#enable_feature_profile}}
import '../feature_profile/di/profile_page_with_dependencies.dart';{{/enable_feature_profile}}
import '../feature_splash/di/splash_page_with_dependencies.dart';
import '../feature_splash/services/splash_service.dart';{{#enable_feature_widget_toolkit}}
import '../feature_widget_toolkit/di/widget_toolkit_with_dependencies.dart';{{/enable_feature_widget_toolkit}}
import '../lib_permissions/services/permissions_service.dart';
import 'models/route_data_model.dart';
import 'models/route_model.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart';
part 'routes/onboarding_routes.dart';{{#enable_feature_profile}}
part 'routes/profile_routes.dart';{{/enable_feature_profile}}
part 'routes/routes.dart';
part 'routes/showcase_routes.dart';

/// A wrapper class implementing all the navigation logic and providing
/// [GoRouter] instance through its getter method [AppRouter.router].
///
/// `AppRouter` depends on [CoordinatorBloc] so the user can be redirected to
/// specific page if the `isAuthenticated` state changes (It can be used with
/// some other global state change as well).
class AppRouter {
  AppRouter({
    required this.coordinatorBloc,
    required this.rootNavigatorKey,
    required this.shellNavigatorKey,
  });

  final CoordinatorBlocType coordinatorBloc;
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> shellNavigatorKey;

  late final _GoRouterRefreshStream _refreshListener =
      _GoRouterRefreshStream(coordinatorBloc.states.isAuthenticated,
{{#enable_feature_otp}}coordinatorBloc.states.isOtpConfirmed {{/enable_feature_otp}});

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const SplashRoute().location,
    routes: _appRoutesList(),
    redirect: _pageRedirections,
    refreshListenable: _refreshListener,
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
  );

  List<RouteBase> _appRoutesList() => [
        $splashRoute,
        $loginRoute,{{#enable_feature_otp}}
        $otpRoute,{{/enable_feature_otp}}
        ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (context, state, child) => HomePage(
                  child: child,
                ),
            routes: [
              $dashboardRoute,{{#enable_feature_counter}}
              $counterRoute,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
              $widgetToolkitRoute,{{/enable_feature_widget_toolkit}}{{#enable_feature_deeplinks}}
              $deepLinksRoute,{{/enable_feature_deeplinks}}{{#enable_feature_profile}}
              $profileRoute,{{/enable_feature_profile}}
            ]),
      ];

  /// This method contains all redirection logic.
  FutureOr<String?> _pageRedirections(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (_refreshListener.isLoggedIn && state.queryParameters['from'] != null) {
      return state.queryParameters['from'];
    }
{{^enable_feature_otp}}
    if (_refreshListener.isLoggedIn &&
        state.matchedLocation == const LoginRoute().location) {
      return const DashboardRoute().location;
    } {{/enable_feature_otp}}
{{#enable_feature_otp}}
    if (_refreshListener.isLoggedIn &&
        state.matchedLocation == const LoginRoute().location) {
      return const OtpRoute().location;
    }
    if (_refreshListener.isLoggedIn &&
        _refreshListener.isOtpConfirmed &&
        state.matchedLocation == const OtpRoute().location) {
      return const DashboardRoute().location;
    }
{{/enable_feature_otp}}
    if (state.matchedLocation == const SplashRoute().location) {
      return null;
    }
    if (!context.read<SplashService>().isAppInitialized) {
      return '${const SplashRoute().location}?from=${state.location}';
    }

    final pathInfo =
        router.routeInformationParser.matcher.findMatch(state.location);

    final routeName = RouteModel.getRouteNameByFullPath(pathInfo.fullPath);

    final hasPermissions = routeName != null
        ? await context
            .read<PermissionsService>()
            .hasPermission(routeName, graceful: true)
        : true;

    if (!_refreshListener.isLoggedIn && !hasPermissions) {
      return '${const LoginRoute().location}?from=${state.location}';
    }

    
    if (!hasPermissions) {
      return const DashboardRoute().location;
    }

    return null;
  }
}
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<bool> stream,
{{#enable_feature_otp}} Stream<bool> streamOTP{{/enable_feature_otp}}) {
    _subscription =
      stream.listen(
        (bool isLoggedIn) {
          this.isLoggedIn = isLoggedIn;
          notifyListeners();
        },
      );
{{#enable_feature_otp}}
     _subscriptionOtp = streamOTP.listen((bool isOtpConfirmed) {
        this.isOtpConfirmed = isOtpConfirmed;
        notifyListeners();
      });{{/enable_feature_otp}}
  }

  late final StreamSubscription<bool> _subscription;{{#enable_feature_otp}}
  late final StreamSubscription<bool> _subscriptionOtp; {{/enable_feature_otp}}
  late bool isLoggedIn = false;
  {{#enable_feature_otp}}
  late bool isOtpConfirmed = false;{{/enable_feature_otp}}
  @override
  void dispose() {

    _subscription.cancel();{{#enable_feature_otp}}
    _subscriptionOtp.cancel();{{/enable_feature_otp}}
    super.dispose();
  }
}
