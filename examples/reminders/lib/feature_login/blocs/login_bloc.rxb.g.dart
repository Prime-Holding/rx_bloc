// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'login_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class LoginBlocType extends RxBlocTypeBase {
  LoginBlocEvents get events;
  LoginBlocStates get states;
}

/// [$LoginBloc] extended by the [LoginBloc]
/// {@nodoc}
abstract class $LoginBloc extends RxBlocBase
    implements LoginBlocEvents, LoginBlocStates, LoginBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setUsername]
  final _$setUsernameEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [setPassword]
  final _$setPasswordEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [login]
  final _$loginEvent = PublishSubject<void>();

  /// The state of [username] implemented in [_mapToUsernameState]
  late final Stream<String> _usernameState = _mapToUsernameState();

  /// The state of [password] implemented in [_mapToPasswordState]
  late final Stream<String> _passwordState = _mapToPasswordState();

  /// The state of [loggedIn] implemented in [_mapToLoggedInState]
  late final Stream<bool> _loggedInState = _mapToLoggedInState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  void setUsername(String username) => _$setUsernameEvent.add(username);

  @override
  void setPassword(String password) => _$setPasswordEvent.add(password);

  @override
  void login() => _$loginEvent.add(null);

  @override
  Stream<String> get username => _usernameState;

  @override
  Stream<String> get password => _passwordState;

  @override
  Stream<bool> get loggedIn => _loggedInState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  Stream<String> _mapToUsernameState();

  Stream<String> _mapToPasswordState();

  Stream<bool> _mapToLoggedInState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  LoginBlocEvents get events => this;

  @override
  LoginBlocStates get states => this;

  @override
  void dispose() {
    _$setUsernameEvent.close();
    _$setPasswordEvent.close();
    _$loginEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
