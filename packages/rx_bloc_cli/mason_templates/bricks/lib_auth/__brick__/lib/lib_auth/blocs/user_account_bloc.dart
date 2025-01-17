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
  ConnectableStream<bool> get isLoading;

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
    isLoading.connect().addTo(_compositeSubscription);

    _$logoutEvent
        .throttleTime(const Duration(seconds: 1))
        .exhaustMap((value) => _logOut().asResultStream())
        .setResultStateHandler(this)
        .listen(null)
        .addTo(_compositeSubscription);
  }

  final UserAccountService _userAccountService;
  final CoordinatorBlocType _coordinatorBloc;
  final AuthService _authService;
  final RouterBlocType _routerBloc;

Future<bool> _logOut() async {
  await _userAccountService.logout();
  _coordinatorBloc.events.authenticated(isAuthenticated: false);{{#enable_feature_otp}}
  _coordinatorBloc.events.otpConfirmed(isOtpConfirmed: false);{{/enable_feature_otp}}{{#enable_pin_code}}
  _coordinatorBloc.events.userLoggedOut();
  _coordinatorBloc.events.pinCodeConfirmed(isPinCodeConfirmed: false);{{/enable_pin_code}}
  _routerBloc.events.go(const LoginRoute());
  return false;
}

@override
  ConnectableStream<bool> _mapToLoggedInState() => Rx.merge([
        _coordinatorBloc.states.isAuthenticated,
        _authService.isAuthenticated().asStream(),
      ]){{#enable_pin_code}}
      .doOnData((isUserLoggedIn) {
        if(isUserLoggedIn){
          _coordinatorBloc.events.checkUserLoggedIn();
        }
      }){{/enable_pin_code}}
     .publishReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  ConnectableStream<bool> _mapToIsLoadingState() => loadingState.publish();
}
