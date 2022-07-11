import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/firebase_service.dart';
import 'coordinator_bloc.dart';

part 'firebase_bloc.rxb.g.dart';

part 'firebase_bloc_extensions.dart';

/// A contract class containing all events of the FirebaseBloC.
abstract class FirebaseBlocEvents {
  void logIn({bool anonymous = false});
}

/// A contract class containing all states of the FirebaseBloC.
abstract class FirebaseBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  ConnectableStream<void> get countersUpdated;

  Stream<bool> get loggedIn;
}

@RxBloc()
class FirebaseBloc extends $FirebaseBloc {
  FirebaseBloc(this._service, this._coordinatorBloc) {
    countersUpdated.connect().disposedBy(_compositeSubscription);
  }

  final FirebaseService _service;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  ConnectableStream<void> _mapToCountersUpdatedState() =>
      _coordinatorBloc.states.onCountersUpdated
          .switchMap((counters) => _service
              .updateCountersInDataSource(
                  completeCount: counters.complete,
                  incompleteCount: counters.incomplete)
              .asStream())
          .publish();

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToLoggedInState() => _$logInEvent
      .switchMap((anonymousLogin) {
        Stream<Result<bool>> result;
        if (anonymousLogin) {
          result = _service.logIn(anonymousLogin).asResultStream();
          return result;
        } else {
          result = _service.logIn(anonymousLogin).asResultStream();
          return result;
        }
      })
      .setResultStateHandler(this)
      .whereSuccess()
      .startWith(false);
}
