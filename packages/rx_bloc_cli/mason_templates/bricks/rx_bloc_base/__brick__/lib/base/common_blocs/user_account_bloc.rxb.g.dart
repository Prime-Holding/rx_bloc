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

  /// Тhe [Subject] where events sink to by calling [logout]
  final _$logoutEvent = PublishSubject<void>();

  /// The state of [loggedIn] implemented in [_mapToLoggedInState]
  late final Stream<bool> _loggedInState = _mapToLoggedInState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  void logout() => _$logoutEvent.add(null);

  @override
  Stream<bool> get loggedIn => _loggedInState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  Stream<bool> _mapToLoggedInState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  UserAccountBlocEvents get events => this;

  @override
  UserAccountBlocStates get states => this;

  @override
  void dispose() {
    _$logoutEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
