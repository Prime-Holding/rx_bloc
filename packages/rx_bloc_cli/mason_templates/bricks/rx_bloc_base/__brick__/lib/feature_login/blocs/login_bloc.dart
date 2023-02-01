{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/user_account_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/credentials_model.dart';
import '../services/login_validator_service.dart';

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
  Stream<ErrorModel> get errors;
}

@RxBloc()
class LoginBloc extends $LoginBloc {
  LoginBloc(
    this._coordinatorBloc,
    this._userAccountService,
    this._validatorService,
  );

  final CoordinatorBlocType _coordinatorBloc;
  final UserAccountService _userAccountService;
  final LoginValidatorService _validatorService;

  @override
  Stream<String> _mapToUsernameState() => _$setUsernameEvent
      .map(_validatorService.validateEmail)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPasswordState() => Rx.merge([
        _$setPasswordEvent.map(_validatorService.validatePassword),
        errorState.mapToFieldException(_$setPasswordEvent),
      ]).startWith('').shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToLoggedInState() => _$loginEvent
      .validateCredentials(this)
      .throttleTime(const Duration(seconds: 1))
      .switchMap(
        (args) => _userAccountService
            .login(username: args.username, password: args.password)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .emitLoggedInToCoordinator(_coordinatorBloc)
      .startWith(false)
      .share();

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
