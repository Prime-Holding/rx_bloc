{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
{{#enable_feature_onboarding}}
import '../../base/common_services/onboarding_service.dart';{{/enable_feature_onboarding}}
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';{{#has_authentication}}
import '../../lib_auth/services/auth_service.dart';{{/has_authentication}}{{#enable_pin_code}}
import '../../lib_pin_code/models/pin_code_arguments.dart';
import '../../lib_pin_code/services/create_pin_code_service.dart';{{/enable_pin_code}}
import '../../lib_router/blocs/router_bloc.dart';
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
    RouterBlocType navigationBloc,
    SplashService splashService,{{#has_authentication}}
    AuthService authService,{{/has_authentication}}{{#enable_feature_onboarding}}
    OnboardingService onboardingService,{{/enable_feature_onboarding}}{{#enable_pin_code}}
    CreatePinCodeService pinCodeService,{{/enable_pin_code}} {
    String? redirectLocation,
  })  : _navigationBloc = navigationBloc,
        _splashService = splashService,{{#has_authentication}}
        _authService = authService,{{/has_authentication}}{{#enable_feature_onboarding}}
        _onboardingService = onboardingService,{{/enable_feature_onboarding}}{{#enable_pin_code}}
        _pinCodeService = pinCodeService,{{/enable_pin_code}}
        _redirectLocation = redirectLocation {
    errors.connect().addTo(_compositeSubscription);
    _$initializeAppEvent
        .throttleTime(const Duration(seconds: 1))
        .startWith(null)
        .switchMap((_) => initializeAppAndNavigate().asResultStream())
        .setResultStateHandler(this)
        .publishReplay(maxSize: 1)
        .connect()
        .addTo(_compositeSubscription);
  }

  final RouterBlocType _navigationBloc;
  final SplashService _splashService;{{#has_authentication}}
  final AuthService _authService;{{/has_authentication}}{{#enable_feature_onboarding}}
  final OnboardingService _onboardingService;{{/enable_feature_onboarding}}
  final String? _redirectLocation;{{#enable_pin_code}}
  final CreatePinCodeService _pinCodeService; {{/enable_pin_code}}

  Future<void> initializeAppAndNavigate() async {
    await _splashService.initializeApp();

    if (_redirectLocation != null) {
      _navigationBloc.events.goToLocation(_redirectLocation!);
    } else { {{^has_authentication}}
      _navigationBloc.events.go(const DashboardRoute());{{/has_authentication}}{{#has_authentication}}

      if (await _authService.isAuthenticated()) {
        {{#enable_feature_onboarding}}final user = await _onboardingService.getMyUser();

        if (!user.confirmedCredentials.email) {
          return _navigationBloc.events
              .pushReplace(OnboardingEmailConfirmationRoute(user.email));
        }

        if (!user.confirmedCredentials.phone) {
          return _navigationBloc.events
              .pushReplace(const OnboardingPhoneRoute());
        }

        {{/enable_feature_onboarding}}{{#enable_pin_code}}if(await _pinCodeService.getPinCode() != null) {
          return _navigationBloc.events.go(const VerifyPinCodeRoute(),
              extra: const PinCodeArguments(title: 'Enter Pin Code'));
        }{{/enable_pin_code}}

        return _navigationBloc.events.go(const DashboardRoute());
      }
      return _navigationBloc.events.go(const LoginRoute());{{/has_authentication}}
    }
  }

  @override
  ConnectableStream<ErrorModel?> _mapToErrorsState() => Rx.merge([
        errorState.mapToErrorModel(),
        loadingState.where((loading) => loading).map((_) => null),
      ]).publish();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
