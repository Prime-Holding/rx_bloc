{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/common_services/onboarding_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

part 'onboarding_email_confirmed_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingEmailConfirmedBloC.
abstract class OnboardingEmailConfirmedBlocEvents {
  /// Verify the user's email with the provided token
  void verifyEmail();

  /// Redirect back to the initial page of the process
  void goToInitialPage();

  /// Redirect to the phone page to continue onboarding
  /// or profile page if the user is changing the email
  void goToNextPage();
}

/// A contract class containing all states of the OnboardingEmailConfirmedBloC.
abstract class OnboardingEmailConfirmedBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// Returns true when the email is verified
  ConnectableStream<UserModel> get data;

  /// The routing state for navigating to login/phone page
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class OnboardingEmailConfirmedBloc extends $OnboardingEmailConfirmedBloc {
  OnboardingEmailConfirmedBloc(
    this._verifyEmailToken,
    this._isOnboarding,
    this._onboardingService,
    this._routerBloc,
  ) {
    onRouting.connect().addTo(_compositeSubscription);
    data.connect().addTo(_compositeSubscription);
  }

  final String _verifyEmailToken;
  final bool _isOnboarding;
  final OnboardingService _onboardingService;
  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<UserModel> _mapToDataState() => _$verifyEmailEvent
      .startWith(null)
      .throttleTime(actionDebounceDuration)
      .switchMap((value) => _onboardingService
          .confirmEmail(token: _verifyEmailToken)
          .asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publishReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<void> _mapToOnRoutingState() => Rx.merge([
        _$goToNextPageEvent.doOnData(
          (_) {
            if (_isOnboarding) {
              _routerBloc.events.pushReplace(const OnboardingPhoneRoute());
            } else {
              _routerBloc.events.go(const ProfileRoute());
            }
          },
        ),
        _$goToInitialPageEvent.doOnData((_) {
          if (_isOnboarding) {
            _routerBloc.events.go(const LoginRoute());
          } else {
            _routerBloc.events.go(const ProfileRoute());
          }
        }),
      ]).publishReplay(maxSize: 1);
}
