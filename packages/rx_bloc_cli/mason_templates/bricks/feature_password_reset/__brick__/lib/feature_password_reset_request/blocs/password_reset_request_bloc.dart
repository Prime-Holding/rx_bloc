{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/models/errors/error_model.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/password_reset_request_service.dart';

part 'password_reset_request_bloc.rxb.g.dart';

/// A contract class containing all events of the PasswordResetRequestBloC.
abstract class PasswordResetRequestBlocEvents {
  /// Sets the currently entered email
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String email);

  /// Requests the password reset
  void request();

  void navigateToNextStep(String email);
}

/// A contract class containing all states of the PasswordResetRequestBloC.
abstract class PasswordResetRequestBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// State indicating whether the user has requested the password reset
  ConnectableStream<void> get requested;

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
class PasswordResetRequestBloc extends $PasswordResetRequestBloc {
  PasswordResetRequestBloc(
    this._passwordResetRequestService,
    this._validatorService,
    this._routerBloc,
  ) {
    requested.connect().addTo(_compositeSubscription);
    onRouting.connect().addTo(_compositeSubscription);
  }

  final CredentialsValidatorService _validatorService;
  final PasswordResetRequestService _passwordResetRequestService;
  final RouterBlocType _routerBloc;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<String> _mapToEmailState() => _$setEmailEvent
      .map(_validatorService.validateEmail)
      .startWith('')
      .shareReplay(maxSize: 1);

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$navigateToNextStepEvent
      .map((email) =>
          _routerBloc.events.push(PasswordResetConfirmationRoute(email)))
      .publishReplay(maxSize: 1);

  @override
  ConnectableStream<void> _mapToRequestedState() => _$requestEvent
      .throttleTime(actionDebounceDuration)
      .withLatestFrom<Result<String>, String?>(
          email.asResultStream(),
          (
            _,
            emailResult,
          ) =>
              _validateAndReturnEmail(
                emailResult,
              ))
      .whereType<String>()
      .exhaustMap(
        (email) => _passwordResetRequestService
            .requestPasswordReset(email: email)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .doOnData((email) => navigateToNextStep(email))
      .publish();

  String? _validateAndReturnEmail(Result<String> emailResult) {
    if (emailResult is ResultError || emailResult is ResultLoading) {
      return null;
    }

    return (emailResult as ResultSuccess<String>).data;
  }

  @override
  Stream<bool> _mapToShowFieldErrorsState() => _$requestEvent
      .mapTo(true)
      .startWith(false)
      .share();
}
