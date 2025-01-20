import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/models/errors/error_model.dart';
import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../base/models/user_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/email_change_service.dart';

part 'email_change_bloc.rxb.g.dart';

/// A contract class containing all events of the EmailChangeBloC.
abstract class EmailChangeBlocEvents {
  /// Sets the currently entered email
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String email);

  /// Starts email change for user with the currently entered email
  void changeEmail();

  void navigateToNextStep(UserModel user);
}

/// A contract class containing all states of the EmailChangeBloC.
abstract class EmailChangeBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The currently entered email state
  Stream<String> get email;

  /// State indicating whether the user successfully changed the email
  ConnectableStream<UserModel> get emailChanged;

  /// The state indicating whether we show field errors to the user
  Stream<bool> get showFieldErrors;

  /// The routing state
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class EmailChangeBloc extends $EmailChangeBloc {
  EmailChangeBloc(
    this.emailChangeService,
    this._validatorService,
    this._routerBloc,
  ) {
    emailChanged.connect().addTo(_compositeSubscription);
    onRouting.connect().addTo(_compositeSubscription);
  }

  final EmailChangeService emailChangeService;
  final CredentialsValidatorService _validatorService;
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
  ConnectableStream<UserModel> _mapToEmailChangedState() => _$changeEmailEvent
      .withLatestFrom(email.asResultStream(),
          (_, emailResult) => _validateEmail(emailResult))
      .whereNotNull()
      .switchMap(
          (email) => emailChangeService.changeEmail(email).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .doOnData((user) => navigateToNextStep(user))
      .publish();

  @override
  Stream<bool> _mapToShowFieldErrorsState() => _$changeEmailEvent
      .switchMap((_) => email
          .map((email) => email.isNotEmpty)
          .onErrorReturn(false)
          .mapTo(true))
      .startWith(false)
      .share();

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$navigateToNextStepEvent
      .withLatestFrom(email, (user, email) => user.copyWith(email: email))
      .switchMap((user) => _navigateToNextStep(user).asResultStream())
      .setResultStateHandler(this)
      .publishReplay(maxSize: 1);

  Future<void> _navigateToNextStep(UserModel user) async {
    _routerBloc.events.pop();
    _routerBloc.events.push(ConfirmEmailRoute(user.email));
  }

  String? _validateEmail(Result<String> emailResult) {
    if (emailResult is ResultSuccess) {
      return (emailResult as ResultSuccess<String>).data;
    } else {
      return null;
    }
  }
}
