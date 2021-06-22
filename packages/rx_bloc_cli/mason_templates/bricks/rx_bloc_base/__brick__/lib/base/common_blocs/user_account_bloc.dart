import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../common_use_cases/login_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../utils/validators/validators.dart';

part 'user_account_bloc.rxb.g.dart';
part 'user_account_bloc_extensions.dart';

// ignore_for_file: avoid_types_on_closure_parameters

abstract class UserAccountBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setUsername(String username);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  void login();

  void logout();
}

abstract class UserAccountBlocStates {
  /// State indicating whether the user is logged in successfully
  Stream<bool> get loggedIn;

  /// The currently entered username state
  Stream<String> get username;

  /// The currently entered password state
  Stream<String> get password;

  /// The state indicating whether we show errors to the user
  Stream<bool> get showErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;
}

@RxBloc()
class UserAccountBloc extends $UserAccountBloc {
  UserAccountBloc(
    this._loginUseCase,
    this._logoutUseCase, {
    this.fieldValidators = const LoginFieldValidators(),
  });

  final LoginFieldValidators fieldValidators;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  @override
  Stream<bool> _mapToLoggedInState() => Rx.merge([
        _$logoutEvent.logoutUser(this),
        _$loginEvent.validateCredentials(this).loginUser(this),
      ]).startWith(false).shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToUsernameState() => Rx.merge([
        _$setUsernameEvent.validateField(fieldValidators.validateEmail),
        _$logoutEvent.map((_) => ''),
      ]).startWith('').shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPasswordState() => Rx.merge([
        _$setPasswordEvent.validateField(fieldValidators.validatePassword),
        _$logoutEvent.map((_) => ''),
        errorState.map(
          (event) => throw RxFieldException(
            error: 'Wrong email or password',
            fieldValue: _$setPasswordEvent.value,
          ),
        )
      ]).startWith('').shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorsState() => _$loginEvent
      .switchMap((event) => _validateAllFields().map((_) => true))
      .startWith(false)
      .shareReplay(maxSize: 1);
}

class _LoginCredentials {
  _LoginCredentials(this.username, this.password);
  final String username;
  final String password;

  bool equals(_LoginCredentials credentials) =>
      username == credentials.username && password == credentials.password;
}
