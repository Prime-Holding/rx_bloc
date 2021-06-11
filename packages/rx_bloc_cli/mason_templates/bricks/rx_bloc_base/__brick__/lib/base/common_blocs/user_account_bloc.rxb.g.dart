// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'user_account_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class UserAccountBlocType extends RxBlocTypeBase {
  UserAccountBlocEvents get events;
  UserAccountBlocStates get states;
}

/// [$UserAccountBloc] extended by the [UserAccountBloc]
/// {@nodoc}
abstract class $UserAccountBloc extends RxBlocBase
    implements
        UserAccountBlocEvents,
        UserAccountBlocStates,
        UserAccountBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [login]
  final _$loginEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [setUsername]
  final _$setUsernameEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [setPassword]
  final _$setPasswordEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [logout]
  final _$logoutEvent = PublishSubject<void>();

  /// The state of [loggedIn] implemented in [_mapToLoggedInState]
  late final Stream<bool> _loggedInState = _mapToLoggedInState();

  /// The state of [username] implemented in [_mapToUsernameState]
  late final Stream<String> _usernameState = _mapToUsernameState();

  /// The state of [password] implemented in [_mapToPasswordState]
  late final Stream<String> _passwordState = _mapToPasswordState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  void login() => _$loginEvent.add(null);

  @override
  void setUsername(String username) => _$setUsernameEvent.add(username);

  @override
  void setPassword(String password) => _$setPasswordEvent.add(password);

  @override
  void logout() => _$logoutEvent.add(null);

  @override
  Stream<bool> get loggedIn => _loggedInState;

  @override
  Stream<String> get username => _usernameState;

  @override
  Stream<String> get password => _passwordState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  Stream<bool> _mapToLoggedInState();

  Stream<String> _mapToUsernameState();

  Stream<String> _mapToPasswordState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  UserAccountBlocEvents get events => this;

  @override
  UserAccountBlocStates get states => this;

  @override
  void dispose() {
    _$loginEvent.close();
    _$setUsernameEvent.close();
    _$setPasswordEvent.close();
    _$logoutEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
