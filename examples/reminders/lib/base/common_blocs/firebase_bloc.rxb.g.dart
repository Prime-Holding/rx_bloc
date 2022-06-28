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

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [countersUpdated] implemented in [_mapToCountersUpdatedState]
  late final ConnectableStream<void> _countersUpdatedState =
      _mapToCountersUpdatedState();

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  ConnectableStream<void> get countersUpdated => _countersUpdatedState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  ConnectableStream<void> _mapToCountersUpdatedState();

  @override
  FirebaseBlocEvents get events => this;

  @override
  FirebaseBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
