{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_auth/services/user_account_service.dart';
import '../models/credentials_model.dart';
import '../services/login_validator_service.dart';

part 'login_bloc.rxb.g.dart';
part 'login_bloc_extensions.dart';

/// A contract class containing all events of the LoginBloC.
abstract class LoginBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String email);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  void login();
}

/// A contract class containing all states of the LoginBloC.
abstract class LoginBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the user is logged in successfully
  ConnectableStream<bool> get loggedIn;

  /// The state indicating whether we show errors to the user
  Stream<bool> get showErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class LoginBloc extends $LoginBloc {
  LoginBloc(
    this._coordinatorBloc,
    this._userAccountService,
    this._validatorService,
  ) {
    loggedIn.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType _coordinatorBloc;
  final UserAccountService _userAccountService;
  final LoginValidatorService _validatorService;

  @override
  Stream<String> _mapToEmailState() => _$setEmailEvent
      .map(_validatorService.validateEmail)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPasswordState() => _$setPasswordEvent
      .map(_validatorService.validatePassword)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  ConnectableStream<bool> _mapToLoggedInState() => _$loginEvent
      .throttleTime(const Duration(seconds: 1))
      .withLatestFrom2<Result<String>, Result<String>, CredentialsModel?>(
          email.asResultStream(),
          password.asResultStream(),
          (_, emailResult, passwordResult) => _validateAndReturnCredentials(
                emailResult,
                passwordResult,
              ))
      .where((args) => args != null)
      .exhaustMap(
        (args) => _userAccountService
            .login(username: args!.email, password: args.password)
            .then((value) => true)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .emitAuthenticatedToCoordinator(_coordinatorBloc)
      .startWith(false)
      .publish();

  CredentialsModel? _validateAndReturnCredentials(
      Result<String> emailResult, Result<String> passwordResult) {
    if (emailResult is ResultError || passwordResult is ResultError) {
      return null;
    }
    if (emailResult is ResultLoading || passwordResult is ResultLoading) {
      return null;
    }

    return CredentialsModel(
      email: (emailResult as ResultSuccess<String>).data,
      password: (passwordResult as ResultSuccess<String>).data,
    );
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorsState() => _$loginEvent
      .switchMap((event) => _validateAllFields().map((_) => true))
      .startWith(false)
      .share();
}
