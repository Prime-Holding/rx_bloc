{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/cancelled_error_model.dart';
import '../services/social_login_service.dart';

part 'social_login_bloc.rxb.g.dart';

/// A contract class containing all events of the SocialLoginBloC
abstract class SocialLoginBlocEvents {
  /// Initiate session with user's Apple credentials
  void login();
}

/// A contract class containing all states of the SocialLoginBloC.
abstract class SocialLoginBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// State indicating whether the user is logged in successfully
  ConnectableStream<bool> get loggedIn;
}

@RxBloc()
class SocialLoginBloc extends $SocialLoginBloc {
  SocialLoginBloc(this._socialLoginService, this._coordinatorBloc) {
    loggedIn.connect().addTo(_compositeSubscription);
  }

  final SocialLoginService _socialLoginService;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<bool> _mapToLoggedInState() => _$loginEvent
      .throttleTime(const Duration(seconds: 1))
      .switchMap(
        (_) => _login().asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .emitAuthenticatedToCoordinator(_coordinatorBloc)
      .startWith(false)
      .publish();

  Future<bool> _login() async {
    try {
      await _socialLoginService.login();
    } on CancelledErrorModel catch (_) {
      return false;
    }

    return true;
  }
}
