// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'coordinator_bloc.dart';

/// CoordinatorBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class CoordinatorBlocType extends RxBlocTypeBase {
  CoordinatorEvents get events;

  CoordinatorStates get states;
}

/// $CoordinatorBloc class - extended by the CoordinatorBloc bloc
/// {@nodoc}
abstract class $CoordinatorBloc extends RxBlocBase
    implements CoordinatorEvents, CoordinatorStates, CoordinatorBlocType {
  ///region Events

  ///region puppyUpdated

  final _$puppyUpdatedEvent = PublishSubject<Puppy>();
  @override
  void puppyUpdated(Puppy puppy) => _$puppyUpdatedEvent.add(puppy);

  ///endregion puppyUpdated

  ///region puppiesWithExtraDetailsFetched

  final _$puppiesWithExtraDetailsFetchedEvent = PublishSubject<List<Puppy>>();
  @override
  void puppiesWithExtraDetailsFetched(List<Puppy> puppies) =>
      _$puppiesWithExtraDetailsFetchedEvent.add(puppies);

  ///endregion puppiesWithExtraDetailsFetched

  ///endregion Events

  ///region States

  ///region onPuppiesUpdated
  Stream<List<Puppy>> _onPuppiesUpdatedState;

  @override
  Stream<List<Puppy>> get onPuppiesUpdated =>
      _onPuppiesUpdatedState ??= _mapToOnPuppiesUpdatedState();

  Stream<List<Puppy>> _mapToOnPuppiesUpdatedState();

  ///endregion onPuppiesUpdated

  ///endregion States

  ///region Type

  @override
  CoordinatorEvents get events => this;

  @override
  CoordinatorStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$puppyUpdatedEvent.close();
    _$puppiesWithExtraDetailsFetchedEvent.close();
    super.dispose();
  }
}
