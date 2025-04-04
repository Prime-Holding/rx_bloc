{{> licence.dart }}

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/common_services/onboarding_service.dart';
import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/credentials_model.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../base/models/user_with_auth_token_model.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/router.dart';

part 'onboarding_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingBloC.
abstract class OnboardingBlocEvents {
  /// Sets the currently entered email
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setEmail(String email);

  /// Sets the currently entered password
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setPassword(String password);

  /// Starts onboarding the user with the currently entered email and password
  void register();

  /// Resumes the onboarding process if the user already has an auth token
  void resumeOnboarding();

  void navigateToNextStep(UserWithAuthTokenModel user);
}

/// A contract class containing all states of the OnboardingBloC.
abstract class OnboardingBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the user is logged in successfully
  ConnectableStream<UserWithAuthTokenModel> get registered;

  /// The state indicating whether we show field errors to the user
  Stream<bool> get showFieldErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The error state for resuming the onboarding process
  Stream<ErrorModel> get resumeOnboardingErrors;

  /// The routing state
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class OnboardingBloc extends $OnboardingBloc {
  OnboardingBloc(
    this._authService,
    this._permissionsService,
    this._onboardingService,
    this._validatorService,
    this._router,
  ) {
    registered.connect().addTo(_compositeSubscription);
    onRouting.connect().addTo(_compositeSubscription);

    _resumeOnboardingIfHasAuthToken();
  }

  Future<void> _resumeOnboardingIfHasAuthToken() async {
    if (await _authService.isAuthenticated()) {
      resumeOnboarding();
    }
  }

  final AuthService _authService;
  final PermissionsService _permissionsService;
  final OnboardingService _onboardingService;
  final CredentialsValidatorService _validatorService;
  final GoRouter _router;

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
  ConnectableStream<UserWithAuthTokenModel> _mapToRegisteredState() => _$registerEvent
      .throttleTime(kBackpressureDuration)
      .withLatestFrom2<Result<String>, Result<String>, CredentialsModel?>(
          email.asResultStream(),
          password.asResultStream(),
          (_, emailResult, passwordResult) => _validateAndReturnCredentials(
                emailResult,
                passwordResult,
              ))
      .whereType<CredentialsModel>()
      .exhaustMap(
        (args) => _onboardingService
            .register(email: args.email, password: args.password)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .doOnData(
          (userWithAuthToken) => navigateToNextStep(userWithAuthToken))
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

  Future<void> _navigateToNextStep(UserModel user) async {
    if (user.confirmedCredentials.email) {
      if (user.confirmedCredentials.phone) {
        await _permissionsService.load();
        return _router.go(const DashboardRoute().routeLocation);
      }

      _router.go(OnboardingPhoneRoute().routeLocation);
    }
    _router.go(
      OnboardingEmailConfirmationRoute(user.email).routeLocation,
    );
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowFieldErrorsState() => _$registerEvent
      .switchMap((event) => Rx.combineLatest2<String, String, bool>(
            email,
            password,
            (username, password) => true,
          ).onErrorReturn(false).map((_) => true))
      .startWith(false)
      .share();

  @override
  Stream<ErrorModel> _mapToResumeOnboardingErrorsState() =>
      _$resumeOnboardingEvent
          .switchMap((_) => _getUserAndResumeOnboarding().asResultStream())
          .setLoadingStateHandler(this)
          .whereError()
          .mapToErrorModel();

  Future<void> _getUserAndResumeOnboarding() async {
    final user = await _onboardingService.getUser();
    await _navigateToNextStep(user);
  }

  Future<void> _saveTokenAndNavigateToNextStep(
      UserWithAuthTokenModel userWithAuthToken) async {
    await _authService.saveAuthToken(userWithAuthToken.authToken);
    await _navigateToNextStep(userWithAuthToken.user);
  }

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$navigateToNextStepEvent
      .switchMap(
          (user) => _saveTokenAndNavigateToNextStep(user).asResultStream())
      .setResultStateHandler(this)
      .publishReplay(maxSize: 1);
}
