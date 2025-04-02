{{> licence.dart }}

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/app/config/app_constants.dart';{{#enable_feature_deeplinks}}
import '../../base/common_services/app_links_service.dart';{{/enable_feature_deeplinks}}{{#enable_feature_onboarding}}
import '../../base/common_services/onboarding_service.dart';{{/enable_feature_onboarding}}
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';{{#has_authentication}}
import '../../lib_auth/services/auth_service.dart';
import '../../lib_router/models/routes_path.dart';{{/has_authentication}}
import '../../lib_router/router.dart';
import '../services/splash_service.dart';

part 'splash_bloc.rxb.g.dart';

/// A contract class containing all events of the SplashBloC.
abstract class SplashBlocEvents {
  /// The event is called when the app is initialized.
  void initializeApp();
}

/// A contract class containing all states of the SplashBloC.
abstract class SplashBlocStates {
  /// The state which group and handle all the loading streams executed in the
  /// BloC.
  Stream<bool> get isLoading;

  /// The state which group and handle all the error streams executed in the
  /// BloC.
  ///
  /// The state is `null` when `isLoading` state is `true`
  ConnectableStream<ErrorModel?> get errors;
}

@RxBloc()
class SplashBloc extends $SplashBloc {
  SplashBloc(
    this._router,
    this._splashService,{{#has_authentication}}
    this._authService,{{/has_authentication}}{{#enable_feature_onboarding}}
    this._onboardingService,{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
    this._appLinksService,{{/enable_feature_deeplinks}}
  ) {
    errors.connect().addTo(_compositeSubscription);

    _$initializeAppEvent
        .throttleTime(kBackpressureDuration)
        .startWith(null)
        .switchMap((_) => _initiateAndRedirect().asResultStream())
        .setResultStateHandler(this)
        .publishReplay(maxSize: 1)
        .connect()
        .addTo(_compositeSubscription);
  }

  final GoRouter _router;
  final SplashService _splashService;{{#has_authentication}}
  final AuthService _authService;{{/has_authentication}}{{#enable_feature_onboarding}}
  final OnboardingService _onboardingService;{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
  final AppLinksService _appLinksService;{{/enable_feature_deeplinks}}

Future<void> _initiateAndRedirect() async {
    //1. Initialize the app before redirecting
    await _splashService.initializeApp(); {{#enable_feature_deeplinks}}
    //2. If the app is cold-started from a deeplink, we don't want to redirect
    final initialLink = await _appLinksService.getInitialLink();
    if (initialLink != null) {
      // navigate to the path
      _router.go(initialLink.path);
      return;
    }

    /// Listen for deep links from the app links service and navigate to the path
    _appLinksService.uriLinkStream.listen((uri) {
      _router.go(uri.path);
      return;
    }); {{/enable_feature_deeplinks}}{{#has_authentication}}

    //3. Redirect the user to the appropriate screen
    if (!await _authService.isAuthenticated()) {
      _router.go(RoutesPath.login);
      return;
    } {{/has_authentication}}{{#enable_feature_onboarding}}

    final user = await _onboardingService.getUser();

    if (!user.confirmedCredentials.email) {
      unawaited(_router.pushReplacement(
        OnboardingEmailConfirmationRoute(user.email).routeLocation,
      ));
    }

    if (!user.confirmedCredentials.phone) {
      unawaited(_router.pushReplacement(
        RoutesPath.onboardingPhone,
      ));
    } {{/enable_feature_onboarding}}

    _router.go(const DashboardRoute().routeLocation);
  }

  @override
  ConnectableStream<ErrorModel?> _mapToErrorsState() => Rx.merge([
        errorState.mapToErrorModel(),
        loadingState.where((loading) => loading).map((_) => null),
      ]).publish();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
