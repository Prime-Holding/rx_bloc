{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../common_services/auth_service.dart';
import '../common_services/user_account_service.dart';
import '../extensions/error_model_extensions.dart';
import '../models/errors/error_model.dart';
import 'coordinator_bloc.dart';

part 'user_account_bloc.rxb.g.dart';

abstract class UserAccountBlocEvents {
  void logout();
}

abstract class UserAccountBlocStates {
  /// State indicating whether the user is logged in successfully
  Stream<bool> get loggedIn;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class UserAccountBloc extends $UserAccountBloc {
  UserAccountBloc(
    UserAccountService userAccountService,
    CoordinatorBlocType coordinatorBloc,
    AuthService authService,
  )   : _userAccountService = userAccountService,
        _coordinatorBloc = coordinatorBloc,
        _authService = authService {
    _$logoutEvent
        .throttleTime(const Duration(seconds: 1))
        .exhaustMap((value) => _userAccountService.logout().asResultStream())
        .setResultStateHandler(this)
        .emitLoggedOutToCoordinator(_coordinatorBloc)
        .listen(null)
        .addTo(_compositeSubscription);
  }

  final UserAccountService _userAccountService;
  final CoordinatorBlocType _coordinatorBloc;
  final AuthService _authService;

  @override
  Stream<bool> _mapToLoggedInState() => Rx.merge([
        _coordinatorBloc.states.isAuthenticated,
        _authService.isAuthenticated().asStream(),
      ]).shareReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
