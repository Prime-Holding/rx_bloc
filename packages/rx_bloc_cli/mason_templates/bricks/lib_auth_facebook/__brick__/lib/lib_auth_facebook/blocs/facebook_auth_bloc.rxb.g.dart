// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'facebook_auth_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class LibAuthFacebookBlocType extends RxBlocTypeBase {
  LibAuthFacebookBlocEvents get events;
  LibAuthFacebookBlocStates get states;
}

/// [$LibAuthFacebookBloc] extended by the [LibAuthFacebookBloc]
/// {@nodoc}
abstract class $LibAuthFacebookBloc extends RxBlocBase
    implements
        LibAuthFacebookBlocEvents,
        LibAuthFacebookBlocStates,
        LibAuthFacebookBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loginWithFb]
  final _$loginWithFbEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [isLoggedInWithFb] implemented in
  /// [_mapToIsLoggedInWithFbState]
  late final ConnectableStream<bool> _isLoggedInWithFbState =
      _mapToIsLoggedInWithFbState();

  @override
  void loginWithFb() => _$loginWithFbEvent.add(null);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  ConnectableStream<bool> get isLoggedInWithFb => _isLoggedInWithFbState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  ConnectableStream<bool> _mapToIsLoggedInWithFbState();

  @override
  LibAuthFacebookBlocEvents get events => this;

  @override
  LibAuthFacebookBlocStates get states => this;

  @override
  void dispose() {
    _$loginWithFbEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
