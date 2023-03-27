import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/facebook_auth_service.dart';

part 'facebook_auth_bloc.rxb.g.dart';

/// A contract class containing all events of the LibAuthFacebookBloC.
abstract class FacebookAuthBlocEvents {
  void loginWithFb();
}

/// A contract class containing all states of the LibAuthFacebookBloC.
abstract class FacebookAuthBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  ConnectableStream<bool> get isLoggedInWithFb;
}

@RxBloc()
class FacebookAuthBloc extends $FacebookAuthBloc {
  FacebookAuthBloc(this._facebookAuthService, this._coordinatorBloc) {
    isLoggedInWithFb.connect().addTo(_compositeSubscription);
  }

  final FacebookAuthService _facebookAuthService;
  final CoordinatorBlocType _coordinatorBloc;
  @override
  ConnectableStream<bool> _mapToIsLoggedInWithFbState() => _$loginWithFbEvent
      .throttleTime(const Duration(seconds: 1))
      .exhaustMap(
        (args) => _facebookAuthService.facebookLogin().asResultStream(),
      )
      .setResultStateHandler(this)
      .whereSuccess()
      .mapTo(true)
      .emitAuthenticatedToCoordinator(_coordinatorBloc)
      .startWith(false)
      .publish();

  /// TODO: Implement error event-to-state logic
  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
