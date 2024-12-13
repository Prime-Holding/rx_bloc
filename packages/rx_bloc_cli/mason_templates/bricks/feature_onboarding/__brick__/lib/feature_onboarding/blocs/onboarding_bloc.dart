{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/users_service.dart';
import '../../base/common_services/validators/login_validator_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/string_extensions.dart';
import '../../base/models/credentials_model.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
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
}

/// A contract class containing all states of the OnboardingBloC.
abstract class OnboardingBlocStates {
  /// The currently entered email state
  Stream<String> get email;

  /// The currently entered password state
  Stream<String> get password;

  /// State indicating whether the user is logged in successfully
  ConnectableStream<bool> get registered;

  /// The state indicating whether we show field errors to the user
  Stream<bool> get showFieldErrors;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
  Stream<ErrorModel> get resumeOnboardingErrors;
}

@RxBloc()
class OnboardingBloc extends $OnboardingBloc {
  OnboardingBloc(
    this._authService,
    this._permissionsService,
    this._usersService,
    this._validatorService,
    this._routerBloc,
  ) {
    registered.connect().addTo(_compositeSubscription);

    resumeOnboardingErrors.listen((_) {});
    _resumeOnboardingIfHasAuthToken();
  }

  Future<void> _resumeOnboardingIfHasAuthToken() async {
    if (await _authService.isAuthenticated()) {
      resumeOnboarding();
    }
  }

  final AuthService _authService;
  final PermissionsService _permissionsService;
  final UsersService _usersService;
  final LoginValidatorService _validatorService;
  final RouterBlocType _routerBloc;

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
  ConnectableStream<bool> _mapToRegisteredState() => _$registerEvent
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
        (args) => _usersService
            .register(email: args!.email, password: args.password)
            .asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .doOnData((userWithAuthToken) {
        _saveToken(userWithAuthToken.authToken);
        _navigateToNextStep(userWithAuthToken.user);
      })
      .map((_) => true)
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
      password: (passwordResult as ResultSuccess<String>).data.toSha256(),
    );
  }

  void _saveToken(AuthTokenModel authToken) {
    // TODO: set profile to not temporary when the onboarding is done
    // (after the SMS confirmation) #893
    // (/api/permissions should be called once again at the end of the flow as well,
    // before redirecting to DashboardRoute)
    _usersService.setIsProfileTemporary(true);
    _authService.saveToken(authToken.token);
    _authService.saveRefreshToken(authToken.refreshToken);
  }

  Future<void> _navigateToNextStep(UserModel user) async {
    if (user.confirmedCredentials.email) {
      if (user.confirmedCredentials.phone) {
        await _usersService.setIsProfileTemporary(false);
        await _permissionsService.getPermissions(force: true);
        return _routerBloc.events.go(const DashboardRoute());
      }

      // TODO: uncomment after #893 is merged
      // return _routerBloc.events.pushReplace(const OnboardingPhoneRoute());
    }
    return _routerBloc.events
        .pushReplace(OnboardingEmailConfirmationRoute(user.email));
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
    final user = await _usersService.getMyUser();
    await _navigateToNextStep(user);
  }
}
