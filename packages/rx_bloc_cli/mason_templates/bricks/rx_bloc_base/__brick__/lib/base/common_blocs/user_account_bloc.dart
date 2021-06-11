import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../common_use_cases/login_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../utils/validators/validators.dart';

part 'user_account_bloc.rxb.g.dart';

// ignore_for_file: avoid_types_on_closure_parameters

abstract class UserAccountBlocEvents {
  void login();

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setUsername(String username);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

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
        _$logoutEvent
            .switchMap((value) {
              // Reset the current username and password
              setUsername('');
              setPassword('');
              return _logoutUseCase.execute().asResultStream();
            })
            .whereSuccess()
            .map((_) => false),
        _$loginEvent
            .switchMap((value) => _validateAllFields())
            .where((isValid) => isValid)
            .withLatestFrom2(
                _$setUsernameEvent,
                _$setPasswordEvent,
                (_, String username, String password) =>
                    _LoginCredentials(username, password))
            .switchMap((args) => _loginUseCase
                .execute(username: args.username, password: args.password)
                .asResultStream())
            .whereSuccess(),
      ]).startWith(false).share();

  @override
  Stream<String> _mapToUsernameState() => _$setUsernameEvent
      .validateField(fieldValidators.validateEmail)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPasswordState() => Rx.merge([
        _$setPasswordEvent.validateField(fieldValidators.validatePassword),
        errorState.map(
          (event) => throw RxFieldException(
            error: 'Wrong email or password',
            fieldValue: _$setPasswordEvent.value,
          ),
        )
      ]).shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorsState() => _$loginEvent
      .switchMap((event) => _validateAllFields().map((event) => true))
      .startWith(false)
      .shareReplay(maxSize: 1);

  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        username,
        password,
        (email, password) => true,
      ).onErrorReturn(false);
}

class _LoginCredentials {
  _LoginCredentials(this.username, this.password);
  final String username;
  final String password;
}
