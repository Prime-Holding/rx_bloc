// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'coordinator_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class CoordinatorBlocType extends RxBlocTypeBase {
  CoordinatorEvents get events;
  CoordinatorStates get states;
}

/// [$CoordinatorBloc] extended by the [CoordinatorBloc]
/// {@nodoc}
abstract class $CoordinatorBloc extends RxBlocBase
    implements CoordinatorEvents, CoordinatorStates, CoordinatorBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [puppyUpdated]
  final _$puppyUpdatedEvent = PublishSubject<Puppy>();

  /// Тhe [Subject] where events sink to by calling
  /// [puppiesWithExtraDetailsFetched]
  final _$puppiesWithExtraDetailsFetchedEvent = PublishSubject<List<Puppy>>();

  /// The state of [onPuppiesUpdated] implemented in
  /// [_mapToOnPuppiesUpdatedState]
  late final Stream<List<Puppy>> _onPuppiesUpdatedState =
      _mapToOnPuppiesUpdatedState();

  @override
  void puppyUpdated(Puppy puppy) => _$puppyUpdatedEvent.add(puppy);

  @override
  void puppiesWithExtraDetailsFetched(List<Puppy> puppies) =>
      _$puppiesWithExtraDetailsFetchedEvent.add(puppies);

  @override
  Stream<List<Puppy>> get onPuppiesUpdated => _onPuppiesUpdatedState;

  Stream<List<Puppy>> _mapToOnPuppiesUpdatedState();

  @override
  CoordinatorEvents get events => this;

  @override
  CoordinatorStates get states => this;

  @override
  void dispose() {
    _$puppyUpdatedEvent.close();
    _$puppiesWithExtraDetailsFetchedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
