{{> licence.dart }}

import 'dart:async';

{{#enable_mfa}}
import 'package:equatable/equatable.dart';{{/enable_mfa}}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../base/common_blocs/coordinator_bloc.dart';{{#enable_feature_deeplinks}}
import '../base/models/deep_link_model.dart';{{/enable_feature_deeplinks}}{{#enable_pin_code}}
import '../base/models/pin_code/create_pin_model.dart';
import '../base/models/pin_code/update_pin_model.dart';{{/enable_pin_code}}{{#enable_feature_counter}}
import '../feature_counter/di/counter_page_with_dependencies.dart';{{/enable_feature_counter}}
import '../feature_dashboard/di/dashboard_page_with_dependencies.dart';{{#enable_feature_deeplinks}}
import '../feature_deep_link_details/di/deep_link_details_page_with_dependencies.dart';
import '../feature_deep_link_list/di/deep_link_list_page_with_dependencies.dart';{{/enable_feature_deeplinks}}{{#enable_feature_onboarding}}
import '../feature_email_change/di/email_change_page_with_dependencies.dart';{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
import '../feature_enter_message/di/enter_message_with_dependencies.dart';{{/enable_feature_deeplinks}}
import '../feature_home/views/home_page.dart';{{#has_authentication}}{{#enable_login}}
import '../feature_login/di/login_page_with_dependencies.dart';{{/enable_login}}{{^enable_login}}
import '../feature_login/views/login_page.dart';{{/enable_login}}{{/has_authentication}}{{#enable_mfa}}
import '../feature_mfa/di/mfa_page_with_dependencies.dart';{{/enable_mfa}}
import '../feature_notifications/di/notifications_page_with_dependencies.dart';{{#enable_feature_onboarding}}
import '../feature_onboarding_email_confirmation/di/change_email_confirmation_page_with_dependencies.dart';
import '../feature_onboarding_email_confirmation/di/change_email_confirmed_page_with_dependencies.dart';
import '../feature_onboarding/di/onboarding_page_with_dependencies.dart';
import '../feature_onboarding_email_confirmation/di/onboarding_email_confirmation_page_with_dependencies.dart';
import '../feature_onboarding_email_confirmation/di/onboarding_email_confirmed_page_with_dependencies.dart';
import '../feature_onboarding_phone_confirmation/di/onboarding_phone_confirm_page_with_dependencies.dart';
import '../feature_onboarding_phone_confirmation/di/onboarding_phone_page_with_dependencies.dart';{{/enable_feature_onboarding}}{{#enable_feature_otp}}
import '../feature_otp/di/otp_page_with_dependencies.dart';{{/enable_feature_otp}}{{#enable_pin_code}}
import '../feature_pin_code/di/set_pin_page_with_dependencies.dart';
import '../feature_pin_code/di/update_pin_page_with_dependencies.dart';
import '../feature_pin_code/views/verify_pin_code_page.dart';{{/enable_pin_code}}{{#enable_profile}}
import '../feature_profile/di/profile_page_with_dependencies.dart';{{/enable_profile}}{{#enable_feature_qr_scanner}}
import '../feature_qr_scanner/di/qr_scanner_page_with_dependencies.dart';{{/enable_feature_qr_scanner}}{{#has_showcase}}
import '../feature_showcase/views/showcase_page.dart';{{/has_showcase}}
import '../feature_splash/di/splash_page_with_dependencies.dart';
import '../feature_splash/services/splash_service.dart';{{#enable_feature_widget_toolkit}}
import '../feature_widget_toolkit/di/widget_toolkit_with_dependencies.dart';{{/enable_feature_widget_toolkit}}{{#enable_mfa}}
import '../lib_mfa/methods/otp/di/mfa_otp_page_with_dependencies.dart';
import '../lib_mfa/methods/pin_biometric/di/mfa_pin_biometrics_page_with_dependencies.dart';
import '../lib_mfa/models/mfa_response.dart';{{/enable_mfa}}
import '../lib_permissions/services/permissions_service.dart';
import 'models/route_data_model.dart';
import 'models/route_model.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart'; {{#enable_mfa}}
part 'routes/mfa_routes.dart';{{/enable_mfa}}{{#enable_feature_onboarding}}
part 'routes/change_email_routes.dart';
part 'routes/change_phone_number_routes.dart';{{/enable_feature_onboarding}}{{#has_authentication}}
part 'routes/onboarding_routes.dart';{{/has_authentication}}{{#enable_profile}}
part 'routes/profile_routes.dart';{{/enable_profile}}{{#enable_feature_onboarding}}
part 'routes/registration_routes.dart';{{/enable_feature_onboarding}}
part 'routes/routes.dart';{{#has_showcase}}
part 'routes/showcase_routes.dart';{{/has_showcase}}

/// A wrapper class implementing all the navigation logic and providing
/// [GoRouter] instance through its getter method [AppRouter.router].
///
/// `AppRouter` depends on [CoordinatorBloc] so the user can be redirected to
/// specific page if the `isAuthenticated` state changes (It can be used with
/// some other global state change as well).
class AppRouter {
  AppRouter({
    required this.coordinatorBloc,
  });

  final CoordinatorBlocType coordinatorBloc;
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutesPath.splash,
    routes: $appRoutes,
    redirect: {{^analytics}}_pageRedirections{{/analytics}}{{#analytics}}_pageRedirectionsWithAnalytics{{/analytics}},
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
  );{{#analytics}}

  /// Analytics
  FutureOr<String?> _pageRedirectionsWithAnalytics(
    BuildContext context,
    GoRouterState state,
  ) async {
    final redirectLocation = await _pageRedirections(context, state);
    coordinatorBloc.events
        .navigationChanged(redirectLocation ?? state.uri.path);
    return redirectLocation;
  }{{/analytics}}

  /// This method contains all redirection logic.
  FutureOr<String?> _pageRedirections(BuildContext context,
      GoRouterState state,) async {
    final permissionsService = context.read<PermissionsService>();
    final splashService = context.read<SplashService>();
    final messenger = ScaffoldMessenger.of(context);
    // If route is splash there is no need to redirect so we return null
    if (RoutesPath.splash == state.uri.path) {
      return null;
    }
    // Ensure the app is initialized before navigating to any page.
    else if (RoutesPath.splash != state.uri.path) {
      await splashService.appInitialized;
    }

    // Ensure the user has the required permissions before navigating to any page.
    if (!await _hasPermissionForURI(state.uri, permissionsService)) {
      messenger.showSnackBar(SnackBar(content: const Text('Access Denied')));
      throw GoException('Access Denied');
    }

    return null;
  }

  Future<bool> _hasPermissionForURI(
    Uri uri,
    PermissionsService permissionsService,
  ) async {
    final pathInfo = router.routeInformationParser.configuration.findMatch(uri);
    final routeName = RouteModel.getRouteNameByFullPath(pathInfo.fullPath);
    if (routeName == null) {
      return false;
    }

    return await permissionsService.hasPermission(routeName, graceful: false);
  }
}