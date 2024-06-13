// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'splash_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class SplashBlocType extends RxBlocTypeBase {
  SplashBlocEvents get events;
  SplashBlocStates get states;
}

/// [$SplashBloc] extended by the [SplashBloc]
/// @nodoc
abstract class $SplashBloc extends RxBlocBase
    implements SplashBlocEvents, SplashBlocStates, SplashBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [initializeApp]
  final _$initializeAppEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String?> _errorsState = _mapToErrorsState();

  @override
  void initializeApp() => _$initializeAppEvent.add(null);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String?> get errors => _errorsState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String?> _mapToErrorsState();

  @override
  SplashBlocEvents get events => this;

  @override
  SplashBlocStates get states => this;

  @override
  void dispose() {
    _$initializeAppEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
