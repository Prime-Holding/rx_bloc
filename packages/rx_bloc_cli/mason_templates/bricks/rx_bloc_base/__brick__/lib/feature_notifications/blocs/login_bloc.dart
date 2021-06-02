import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../test_app_utils.dart';

// ignore_for_file: avoid_types_on_closure_parameters

part 'login_bloc.rxb.g.dart';

/// A contract class containing all events of the LoginBloC.
abstract class LoginBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String value);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String value);

  void login();
}

/// A contract class containing all states of the LoginBloC.
abstract class LoginBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the login has successfully finished
  Stream<bool> get loginComplete;

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
    this.fieldValidators = const LoginFieldValidators(),
  });

  final LoginFieldValidators fieldValidators;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<String> _mapToEmailState() => _$setEmailEvent
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
  Stream<bool> _mapToLoginCompleteState() => _$loginEvent
      .switchMap((value) => _validateAllFields())
      .where((isValid) => isValid)
      .withLatestFrom2(
    _$setEmailEvent,
    _$setPasswordEvent,
        (_, String email, String password) => _tryLogin(email, password),
  )
      .switchMap((value) => Future.value(value).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .share();

  @override
  Stream<bool> _mapToShowErrorsState() => _$loginEvent
      .switchMap((event) => _validateAllFields().map((event) => true))
      .startWith(false)
      .shareReplay(maxSize: 1);

  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
    email,
    password,
        (email, password) => true,
  ).onErrorReturn(false);

  /// With this we check against an backend service and login the user if
  /// the provided credentials are correct (in this example we just return true)
  Future<bool> _tryLogin(String email, String password) => Future.value(true);
}
