{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../common_use_cases/logout_use_case.dart';
import '../extensions/error_model_extensions.dart';
import '../models/errors/error_model.dart';
import '../repositories/auth_repository.dart';
import 'coordinator_bloc.dart';

part 'user_account_bloc.rxb.g.dart';
part 'user_account_bloc_extensions.dart';

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
  UserAccountBloc({
    required LogoutUseCase logoutUseCase,
    required CoordinatorBlocType coordinatorBloc,
    required AuthRepository authRepository,
  })  : _logoutUseCase = logoutUseCase,
        _coordinatorBloc = coordinatorBloc,
        _authRepository = authRepository {
    _$logoutEvent
        .logoutUser(_logoutUseCase)
        .setResultStateHandler(this)
        .emitLoggedOutToCoordinator(_coordinatorBloc)
        .listen(null)
        .addTo(_compositeSubscription);
  }

  final LogoutUseCase _logoutUseCase;
  final CoordinatorBlocType _coordinatorBloc;
  final AuthRepository _authRepository;

  @override
  Stream<bool> _mapToLoggedInState() => Rx.merge([
        _coordinatorBloc.states.isAuthenticated,
        _authRepository.isAuthenticated().asStream(),
      ]).shareReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
