{{> licence.dart }}

import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_use_cases/login_use_case.dart';
import '../../base/extensions/stream_extensions.dart';
import '../../base/utils/validators/validators.dart';

part 'login_bloc.rxb.g.dart';
part 'login_bloc_extensions.dart';

/// A contract class containing all events of the LoginBloC.
abstract class LoginBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setUsername(String username);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  void login();
}

/// A contract class containing all states of the LoginBloC.
abstract class LoginBlocStates {
  /// The currently entered username state
  Stream<String> get username;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the user is logged in successfully
  Stream<bool> get loggedIn;

  /// The state indicating whether we show errors to the user
  Stream<bool> get showErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;
}

@RxBloc()
class LoginBloc extends $LoginBloc {
  LoginBloc({
    required LoginUseCase loginUseCase,
    required CoordinatorBlocType coordinatorBloc,
    LoginFieldValidators fieldValidators = const LoginFieldValidators(),
  })  : _loginUseCase = loginUseCase,
        _fieldValidators = fieldValidators,
        _coordinatorBloc = coordinatorBloc;

  final LoginFieldValidators _fieldValidators;
  final LoginUseCase _loginUseCase;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<String> _mapToUsernameState() => _$setUsernameEvent
      .validateField(_fieldValidators.validateEmail)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPasswordState() => Rx.merge([
        _$setPasswordEvent.validateField(_fieldValidators.validatePassword),
        errorState.mapToFieldException(_$setPasswordEvent),
      ]).startWith('').shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToLoggedInState() => _$loginEvent
      .validateCredentials(this)
      .loginUser(_loginUseCase)
      .setResultStateHandler(this)
      .emitLoggedInToCoordinator(_coordinatorBloc)
      .startWith(false)
      .share();

  @override
  Stream<String> _mapToErrorsState() => errorState.mapFromDio().toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorsState() => _$loginEvent
      .switchMap((event) => _validateAllFields().map((_) => true))
      .startWith(false)
      .share();
}

class _LoginCredentials {
  _LoginCredentials(this.username, this.password);
  final String username;
  final String password;

  bool equals(_LoginCredentials credentials) =>
      username == credentials.username && password == credentials.password;
}
