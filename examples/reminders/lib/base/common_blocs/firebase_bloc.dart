import 'package:firebase_auth/firebase_auth.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/firebase_service.dart';
import 'coordinator_bloc.dart';

part 'firebase_bloc.rxb.g.dart';

part 'firebase_bloc_extensions.dart';

/// A contract class containing all events of the FirebaseBloC.
abstract class FirebaseBlocEvents {
  void logIn({bool anonymous = false, bool setToFalse = false});

  void checkIfUserIsLoggedIn();

  void logOut();
}

/// A contract class containing all states of the FirebaseBloC.
abstract class FirebaseBlocStates {
  /// The loading state
  Stream<LoadingWithTag> get isLoading;

  /// The error state
  Stream<String> get errors;

  ConnectableStream<void> get countersUpdated;

  Stream<User?> get currentUserData;

  Stream<bool> get isUserLoggedIn;

  Stream<bool> get userLoggedOut;

  Stream<bool> get loggedIn;

  ConnectableStream<bool> get loggedOut;
}

@RxBloc()
class FirebaseBloc extends $FirebaseBloc {
  FirebaseBloc(
    this._service,
    this._coordinatorBloc,
  ) {
    countersUpdated.connect().disposedBy(_compositeSubscription);
    loggedOut.connect().disposedBy(_compositeSubscription);
  }

  final FirebaseService _service;
  final CoordinatorBlocType _coordinatorBloc;

  static const tagAnonymous = 'anonymous';
  static const tagFacebook = 'facebook';

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
  Stream<LoadingWithTag> _mapToIsLoadingState() =>
      loadingWithTagState.asBroadcastStream();

  @override
  Stream<bool> _mapToLoggedInState() => _$logInEvent
      .switchMap<Result<bool>>((logInEventArgs) => _service
          .logIn(logInEventArgs.anonymous)
          .asResultStream(
              tag: logInEventArgs.anonymous
                  ? FirebaseBloc.tagAnonymous
                  : FirebaseBloc.tagFacebook))
      .setResultStateHandler(this)
      .whereSuccess()
      .asBroadcastStream();

  @override
  Stream<bool> _mapToIsUserLoggedInState() => _$checkIfUserIsLoggedInEvent
      .switchMap((value) => _service.isUserLoggedIn().asStream());

  @override
  ConnectableStream<bool> _mapToLoggedOutState() => _$logOutEvent
      .switchMap((value) => _service.logOut().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .map((event) => true)
      .onErrorReturn(false)
      .publish();

  @override
  Stream<User?> _mapToCurrentUserDataState() => _service.currentUser;

  @override
  Stream<bool> _mapToUserLoggedOutState() => Rx.merge([
        currentUserData.skip(1).map((event) {
          if (event == null) {
            return true;
          } else {
            return false;
          }
        }),
        loggedOut
      ]).asBroadcastStream();
}
