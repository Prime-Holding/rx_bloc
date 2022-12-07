// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'firebase_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class FirebaseBlocType extends RxBlocTypeBase {
  FirebaseBlocEvents get events;
  FirebaseBlocStates get states;
}

/// [$FirebaseBloc] extended by the [FirebaseBloc]
/// {@nodoc}
abstract class $FirebaseBloc extends RxBlocBase
    implements FirebaseBlocEvents, FirebaseBlocStates, FirebaseBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [logIn]
  final _$logInEvent = PublishSubject<_LogInEventArgs>();

  /// Тhe [Subject] where events sink to by calling [checkIfUserIsLoggedIn]
  final _$checkIfUserIsLoggedInEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [logOut]
  final _$logOutEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<LoadingWithTag> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [currentUserData] implemented in [_mapToCurrentUserDataState]
  late final Stream<User?> _currentUserDataState = _mapToCurrentUserDataState();

  /// The state of [isUserLoggedIn] implemented in [_mapToIsUserLoggedInState]
  late final Stream<bool> _isUserLoggedInState = _mapToIsUserLoggedInState();

  /// The state of [userLoggedOut] implemented in [_mapToUserLoggedOutState]
  late final Stream<bool> _userLoggedOutState = _mapToUserLoggedOutState();

  /// The state of [loggedIn] implemented in [_mapToLoggedInState]
  late final Stream<bool> _loggedInState = _mapToLoggedInState();

  /// The state of [loggedOut] implemented in [_mapToLoggedOutState]
  late final ConnectableStream<bool> _loggedOutState = _mapToLoggedOutState();

  @override
  void logIn({
    bool anonymous = false,
    bool setToFalse = false,
  }) =>
      _$logInEvent.add(_LogInEventArgs(
        anonymous: anonymous,
        setToFalse: setToFalse,
      ));

  @override
  void checkIfUserIsLoggedIn() => _$checkIfUserIsLoggedInEvent.add(null);

  @override
  void logOut() => _$logOutEvent.add(null);

  @override
  Stream<LoadingWithTag> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<User?> get currentUserData => _currentUserDataState;

  @override
  Stream<bool> get isUserLoggedIn => _isUserLoggedInState;

  @override
  Stream<bool> get userLoggedOut => _userLoggedOutState;

  @override
  Stream<bool> get loggedIn => _loggedInState;

  @override
  ConnectableStream<bool> get loggedOut => _loggedOutState;

  Stream<LoadingWithTag> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<User?> _mapToCurrentUserDataState();

  Stream<bool> _mapToIsUserLoggedInState();

  Stream<bool> _mapToUserLoggedOutState();

  Stream<bool> _mapToLoggedInState();

  ConnectableStream<bool> _mapToLoggedOutState();

  @override
  FirebaseBlocEvents get events => this;

  @override
  FirebaseBlocStates get states => this;

  @override
  void dispose() {
    _$logInEvent.close();
    _$checkIfUserIsLoggedInEvent.close();
    _$logOutEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [FirebaseBlocEvents.logIn] event
class _LogInEventArgs {
  const _LogInEventArgs({
    this.anonymous = false,
    this.setToFalse = false,
  });

  final bool anonymous;

  final bool setToFalse;
}
