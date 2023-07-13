{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/auth_service.dart';
import '../services/user_account_service.dart';

part 'user_account_bloc.rxb.g.dart';

abstract class UserAccountBlocEvents {
  /// The event is called on user logout.
  void logout();
}

abstract class UserAccountBlocStates {
  /// The state is updated when the user authentication state is changed.
  ConnectableStream<bool> get loggedIn;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class UserAccountBloc extends $UserAccountBloc {
  UserAccountBloc(
    this._userAccountService,
    this._coordinatorBloc,
    this._authService,
    this._routerBloc,
  ) {
    loggedIn.connect().addTo(_compositeSubscription);

    _$logoutEvent
        .throttleTime(const Duration(seconds: 1))
        .exhaustMap((value) =>
            _userAccountService.logout().then((_) => false).asResultStream())
        .setResultStateHandler(this)
        .whereSuccess()
        .emitAuthenticatedToCoordinator(_coordinatorBloc){{#enable_feature_otp}}
        .emitOtpConfirmedToCoordinator(_coordinatorBloc){{/enable_feature_otp}}{{#enable_pin_code}}
        .emitPinCodeConfirmedToCoordinator(_coordinatorBloc){{/enable_pin_code}}
        .doOnData((_) => _routerBloc.events.go(const LoginRoute()))
        .listen(null)
        .addTo(_compositeSubscription);
  }

  final UserAccountService _userAccountService;
  final CoordinatorBlocType _coordinatorBloc;
  final AuthService _authService;
  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<bool> _mapToLoggedInState() => Rx.merge([
        _coordinatorBloc.states.isAuthenticated,
        _authService.isAuthenticated().asStream(),
      ]){{#enable_pin_code}}
      .doOnData((isUserLoggedIn) {
        if (!isUserLoggedIn) {
           return _coordinatorBloc.events.deleteStoredPin();
        }
      }){{/enable_pin_code}}
     .publishReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
