{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/models/errors/error_model.dart';
import '../../app_extensions.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../feature_password_reset_request/services/password_reset_request_service.dart';
import '../../lib_router/router.dart';
import '../services/password_reset_service.dart';

part 'password_reset_bloc.rxb.g.dart';

/// A contract class containing all events of the PasswordResetBloC.
abstract class PasswordResetBlocEvents {
  /// Send new email link in case the token is invalid
  void sendNewLink();

  /// Navigates to the login page on success or error
  void goToLogin();

  /// Sets the currently entered password
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  /// Resets the password
  void resetPassword();
}

/// A contract class containing all states of the PasswordResetBloC.
abstract class PasswordResetBlocStates {
  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the user has successfully reset the password
  ConnectableStream<bool> get isResetSuccessful;

  /// State indicating whether the token has been resent to the user's email
  ConnectableStream<bool> get isTokenResent;

  /// The state indicating whether we show field errors to the user
  Stream<bool> get showFieldErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The routing state
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class PasswordResetBloc extends $PasswordResetBloc {
  PasswordResetBloc(
    this._passwordResetRequestService,
    this._passwordResetService,
    this._validatorService,
    this._router,
    this._token,
    this._email,
  ) {
    isResetSuccessful.connect().addTo(_compositeSubscription);
    isTokenResent.connect().addTo(_compositeSubscription);
    onRouting.connect().addTo(_compositeSubscription);
  }

  final PasswordResetRequestService _passwordResetRequestService;
  final PasswordResetService _passwordResetService;
  final CredentialsValidatorService _validatorService;
  final GoRouter _router;

  /// The token received from the Email link, to be checked by the backend
  final String _token;
  /// The Email of the user, to be used in case of resending the link
  final String _email;

  @override
  Stream<String> _mapToPasswordState() => _$setPasswordEvent
      .map(_validatorService.validatePassword)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  ConnectableStream<bool> _mapToIsResetSuccessfulState() => _$resetPasswordEvent
      .throttleTime(kBackpressureDuration)
      .withLatestFrom<Result<String>, String?>(
          password.asResultStream(),
          (_, passwordResult) => _validateAndReturnPassword(
                passwordResult,
              ))
      .whereType<String>()
      .exhaustMap(
        (password) => _passwordResetService
            .resetPassword(token: _token, password: password)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .mapTo(true)
      .publish();

  String? _validateAndReturnPassword(Result<String> passwordResult) {
    if (passwordResult is ResultError || passwordResult is ResultLoading) {
      return null;
    }

    return (passwordResult as ResultSuccess<String>).data;
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowFieldErrorsState() =>
      _$resetPasswordEvent.mapTo(true).share();

  @override
  ConnectableStream<bool> _mapToIsTokenResentState() => _$sendNewLinkEvent
      .switchMap((_) => _passwordResetRequestService
          .requestPasswordReset(email: _email)
          .asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .mapTo(true)
      .publishReplay(maxSize: 1);

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$goToLoginEvent
      .doOnData((_) => _router.go(const LoginRoute().location))
      .publishReplay(maxSize: 1);
}
