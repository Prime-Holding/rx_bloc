{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/google_login_service.dart';

part 'google_login_bloc.rxb.g.dart';

/// A contract class containing all events of the GoogleLoginBloC.
abstract class GoogleLoginBlocEvents {
  void googleLogin();
}

/// A contract class containing all states of the GoogleLoginBloC.
abstract class GoogleLoginBlocStates {
  Stream<bool> get isLoading;

  Stream<ErrorModel> get errors;

  ConnectableStream<bool> get isGoogleAuthenticated;
}

@RxBloc()
class GoogleLoginBloc extends $GoogleLoginBloc {
  GoogleLoginBloc(this._googleLoginService, this._coordinatorBloc) {
    isGoogleAuthenticated.connect().addTo(_compositeSubscription);
  }

  final GoogleLoginService _googleLoginService;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<bool> _mapToIsGoogleAuthenticatedState() =>
      _$googleLoginEvent
          .exhaustMap(
            (value) =>
                _googleLoginService.login().then((_) => true).asResultStream(),
          )
          .setResultStateHandler(this)
          .whereSuccess()
          .emitAuthenticatedToCoordinator(_coordinatorBloc)
          .startWith(false)
          .publish();
}
