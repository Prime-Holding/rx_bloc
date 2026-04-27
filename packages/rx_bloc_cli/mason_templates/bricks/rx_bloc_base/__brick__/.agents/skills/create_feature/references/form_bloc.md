```dart
import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_router/router.dart';
import '../services/my_feature_service.dart';

part 'my_feature_bloc.rxb.g.dart';

/// A contract class containing all events of the MyFeatureBloC.
abstract class MyFeatureBlocEvents {
  /// Updates the currently entered email; the latest value is always available as a state.
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String email);

  /// Updates the currently entered password; the latest value is always available as a state.
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  /// Triggers the submission of the form with the currently entered credentials.
  /// The result of the submission is available as a state, and any errors are handled by the error state.
  void submit();
}

/// A contract class containing all states of the MyFeatureBloC.
abstract class MyFeatureBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the submission was successful
  ConnectableStream<bool> get submitted;

  /// The state indicating whether we show errors to the user
  Stream<bool> get showErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class MyFeatureBloc extends $MyFeatureBloc {
  MyFeatureBloc(
          this._coordinatorBloc,
          this._myFeatureService,
          this._validatorService,
          this._router,
          ) {
    submitted.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType _coordinatorBloc;
  final MyFeatureService _myFeatureService;
  final CredentialsValidatorService _validatorService;
  final AppRouter _router;

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
  ConnectableStream<bool> _mapToSubmittedState() => _$submitEvent
          .throttleTime(const Duration(seconds: 1))
          .withLatestFrom2<Result<String>, Result<String>, MyCredentials?>(
    email.asResultStream(),
    password.asResultStream(),
            (_, emailResult, passwordResult) =>
            _validateAndReturnCredentials(emailResult, passwordResult),
  )
          .where((args) => args != null)
          .exhaustMap(
            (args) => _myFeatureService
            .processData(email: args!.email, password: args.password)
            .then((value) => true)
            .asResultStream(),
  )
          .setResultStateHandler(this)
          .whereSuccess()
          .doOnData((_) => _router.go(const DashboardRoute().location))
          .startWith(false)
          .publish();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorsState() =>
          _$submitEvent.mapTo(true).startWith(false);

  MyCredentials? _validateAndReturnCredentials(
          Result<String> emailResult,
          Result<String> passwordResult,
          ) {
    if (emailResult is ResultError || passwordResult is ResultError) {
      return null;
    }
    if (emailResult is ResultLoading || passwordResult is ResultLoading) {
      return null;
    }

    return MyCredentials(
      email: (emailResult as ResultSuccess<String>).data,
      password: (passwordResult as ResultSuccess<String>).data,
    );
  }
}
  ```