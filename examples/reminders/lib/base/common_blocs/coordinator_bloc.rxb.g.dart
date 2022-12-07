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

  /// Тhe [Subject] where events sink to by calling [authenticated]
  final _$authenticatedEvent = PublishSubject<bool>();

  /// Тhe [Subject] where events sink to by calling [reminderDeleted]
  final _$reminderDeletedEvent = PublishSubject<Result<ReminderModel>>();

  /// Тhe [Subject] where events sink to by calling [reminderCreated]
  final _$reminderCreatedEvent = PublishSubject<Result<ReminderModel>>();

  /// Тhe [Subject] where events sink to by calling [reminderUpdated]
  final _$reminderUpdatedEvent = PublishSubject<Result<ReminderPair>>();

  /// Тhe [Subject] where events sink to by calling [updateCounters]
  final _$updateCountersEvent = PublishSubject<UpdatedCounters>();

  @override
  void authenticated({required bool isAuthenticated}) =>
      _$authenticatedEvent.add(isAuthenticated);

  @override
  void reminderDeleted(Result<ReminderModel> reminderResult) =>
      _$reminderDeletedEvent.add(reminderResult);

  @override
  void reminderCreated(Result<ReminderModel> reminderResult) =>
      _$reminderCreatedEvent.add(reminderResult);

  @override
  void reminderUpdated(Result<ReminderPair> reminderPairResult) =>
      _$reminderUpdatedEvent.add(reminderPairResult);

  @override
  void updateCounters(UpdatedCounters counters) =>
      _$updateCountersEvent.add(counters);

  @override
  CoordinatorEvents get events => this;

  @override
  CoordinatorStates get states => this;

  @override
  void dispose() {
    _$authenticatedEvent.close();
    _$reminderDeletedEvent.close();
    _$reminderCreatedEvent.close();
    _$reminderUpdatedEvent.close();
    _$updateCountersEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
