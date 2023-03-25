{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/apple_social_login_service.dart';

part 'apple_login_bloc.rxb.g.dart';

/// A contract class containing all events of the LoginWithAppleBloC.
abstract class AppleLoginBlocEvents {
  /// Initiate session with user's Apple credentials
  void loginWithApple();
}

/// A contract class containing all states of the LoginWithAppleBloC.
abstract class AppleLoginBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// State indicating whether the user is logged in successfully
  ConnectableStream<bool> get loggedIn;
}

@RxBloc()
class AppleLoginBloc extends $AppleLoginBloc {
  AppleLoginBloc(this._appleSocialLoginService, this._coordinatorBloc) {
    loggedIn.connect().addTo(_compositeSubscription);
  }

  final AppleSocialLoginService _appleSocialLoginService;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<bool> _mapToLoggedInState() => _$loginWithAppleEvent
      .throttleTime(const Duration(seconds: 1))
      .exhaustMap((_) =>
          _appleSocialLoginService.login().then((_) => true).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .emitAuthenticatedToCoordinator(_coordinatorBloc)
      .startWith(false)
      .publish();
}
