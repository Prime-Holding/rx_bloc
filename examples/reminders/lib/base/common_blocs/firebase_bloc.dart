import 'package:firebase_auth/firebase_auth.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/firebase_service.dart';
import 'coordinator_bloc.dart';

part 'firebase_bloc.rxb.g.dart';
part 'firebase_bloc_extensions.dart';

/// A contract class containing all events of the FirebaseBloC.
abstract class FirebaseBlocEvents {
  /// Event used to initiate the login process
  void logIn({bool anonymous = false, bool setToFalse = false});

  /// Event used to check if there is a currently logged in user
  void checkIfUserIsLoggedIn();

  /// Event used to initiate the logout process for the currently logged in user
  void logOut();
}

/// A contract class containing all states of the FirebaseBloC.
abstract class FirebaseBlocStates {
  /// The loading state
  Stream<LoadingWithTag> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// State containing the currently logged in user, if any
  Stream<User?> get currentUserData;

  /// State indicating whether there is currently a user logged in
  Stream<bool> get isUserLoggedIn;

  /// State indicating whether currently the user is logged out
  Stream<bool> get userLoggedOut;

  /// State emitting true when the user has successfully logged in. Triggered
  /// by the [logIn] event.
  ConnectableStream<bool> get loggedIn;

  /// State emitting true when the user has successfully logged out. Triggered
  /// by the [logOut] event.
  ConnectableStream<bool> get loggedOut;
}

@RxBloc()
class FirebaseBloc extends $FirebaseBloc {
  FirebaseBloc(
    this._service,
    this._coordinatorBloc,
  ) {
    loggedIn.connect().addTo(_compositeSubscription);
    loggedOut.connect().addTo(_compositeSubscription);
  }

  final FirebaseService _service;
  final CoordinatorBlocType _coordinatorBloc;

  static const tagAnonymous = 'anonymous';
  static const tagFacebook = 'facebook';

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<LoadingWithTag> _mapToIsLoadingState() =>
      loadingWithTagState.asBroadcastStream();

  @override
  ConnectableStream<bool> _mapToLoggedInState() => _$logInEvent
      .switchMap<Result<bool>>((logInEventArgs) => _service
          .logIn(logInEventArgs.anonymous)
          .asResultStream(
              tag: logInEventArgs.anonymous
                  ? FirebaseBloc.tagAnonymous
                  : FirebaseBloc.tagFacebook))
      .setResultStateHandler(this)
      .emitLoggedInToCoordinator(_coordinatorBloc)
      .publishReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsUserLoggedInState() => Rx.merge([
        _service.isUserLoggedIn().asStream(),
        _coordinatorBloc.states.isAuthenticated,
      ]).shareReplay(maxSize: 1);

  @override
  ConnectableStream<bool> _mapToLoggedOutState() => _$logOutEvent
      .switchMap((value) => _service.logOut().asResultStream())
      .setResultStateHandler(this)
      .emitLoggedOutToCoordinator(_coordinatorBloc)
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
