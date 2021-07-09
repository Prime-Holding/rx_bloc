import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../common_use_cases/logout_use_case.dart';
import '../repositories/auth_repository.dart';
import 'coordinator_bloc.dart';

part 'user_account_bloc.rxb.g.dart';
part 'user_account_bloc_extensions.dart';

// ignore_for_file: avoid_types_on_closure_parameters

abstract class UserAccountBlocEvents {
  void logout();
}

abstract class UserAccountBlocStates {
  /// State indicating whether the user is logged in successfully
  Stream<bool> get loggedIn;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;
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
        .listen((_) {})
        .disposedBy(_compositeSubscription);
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
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
