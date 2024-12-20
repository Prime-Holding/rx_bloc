{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/users_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

part 'onboarding_email_confirmed_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingEmailConfirmedBloC.
abstract class OnboardingEmailConfirmedBlocEvents {
  /// Verify the user's email with the provided token
  void verifyEmail();

  /// Redirect back to the login page in case of error
  void goToLogin();

  /// Redirect to the phone entry page to continue onboarding
  void goToPhonePage();
}

/// A contract class containing all states of the OnboardingEmailConfirmedBloC.
abstract class OnboardingEmailConfirmedBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// Returns true when the email is verified
  ConnectableStream<bool> get data;

  /// The routing state for navigating to login/phone page
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class OnboardingEmailConfirmedBloc extends $OnboardingEmailConfirmedBloc {
  OnboardingEmailConfirmedBloc(
    this._verifyEmailToken,
    this._usersService,
    this._routerBloc,
  ) {
    onRouting.connect().addTo(_compositeSubscription);
    data.connect().addTo(_compositeSubscription);
  }

  final String _verifyEmailToken;
  final UsersService _usersService;
  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<bool> _mapToDataState() => _$verifyEmailEvent
      .startWith(null)
      .throttleTime(const Duration(milliseconds: 200))
      .switchMap((value) => _usersService
          .confirmEmail(token: _verifyEmailToken)
          .asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .map((event) => true)
      .publishReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<void> _mapToOnRoutingState() => Rx.merge([
        _$goToPhonePageEvent.map((_) =>
            _routerBloc.events.pushReplace(const OnboardingPhoneRoute())),
        _$goToLoginEvent.map((_) => _routerBloc.events.go(const LoginRoute())),
      ]).publishReplay(maxSize: 1);
}
