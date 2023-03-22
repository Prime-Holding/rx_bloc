// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'google_login_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class GoogleLoginBlocType extends RxBlocTypeBase {
  GoogleLoginBlocEvents get events;
  GoogleLoginBlocStates get states;
}

/// [$GoogleLoginBloc] extended by the [GoogleLoginBloc]
/// {@nodoc}
abstract class $GoogleLoginBloc extends RxBlocBase
    implements
        GoogleLoginBlocEvents,
        GoogleLoginBlocStates,
        GoogleLoginBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [googleLogin]
  final _$googleLoginEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [isGoogleAuthenticated] implemented in
  /// [_mapToIsGoogleAuthenticatedState]
  late final ConnectableStream<bool> _isGoogleAuthenticatedState =
      _mapToIsGoogleAuthenticatedState();

  @override
  void googleLogin() => _$googleLoginEvent.add(null);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  ConnectableStream<bool> get isGoogleAuthenticated =>
      _isGoogleAuthenticatedState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  ConnectableStream<bool> _mapToIsGoogleAuthenticatedState();

  @override
  GoogleLoginBlocEvents get events => this;

  @override
  GoogleLoginBlocStates get states => this;

  @override
  void dispose() {
    _$googleLoginEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
