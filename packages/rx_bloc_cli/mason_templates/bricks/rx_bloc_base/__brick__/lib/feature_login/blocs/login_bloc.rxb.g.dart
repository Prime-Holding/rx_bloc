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

  /// Тhe [Subject] where events sink to by calling [setEmail]
  final _$setEmailEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [setPassword]
  final _$setPasswordEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [login]
  final _$loginEvent = PublishSubject<void>();

  /// The state of [email] implemented in [_mapToEmailState]
  late final Stream<String> _emailState = _mapToEmailState();

  /// The state of [password] implemented in [_mapToPasswordState]
  late final Stream<String> _passwordState = _mapToPasswordState();

  /// The state of [loginComplete] implemented in [_mapToLoginCompleteState]
  late final Stream<bool> _loginCompleteState = _mapToLoginCompleteState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  void setEmail(String value) => _$setEmailEvent.add(value);

  @override
  void setPassword(String value) => _$setPasswordEvent.add(value);

  @override
  void login() => _$loginEvent.add(null);

  @override
  Stream<String> get email => _emailState;

  @override
  Stream<String> get password => _passwordState;

  @override
  Stream<bool> get loginComplete => _loginCompleteState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  Stream<String> _mapToEmailState();

  Stream<String> _mapToPasswordState();

  Stream<bool> _mapToLoginCompleteState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  LoginBlocEvents get events => this;

  @override
  LoginBlocStates get states => this;

  @override
  void dispose() {
    _$setEmailEvent.close();
    _$setPasswordEvent.close();
    _$loginEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
