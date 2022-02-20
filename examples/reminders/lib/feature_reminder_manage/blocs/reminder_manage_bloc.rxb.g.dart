// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'reminder_manage_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ReminderManageBlocType extends RxBlocTypeBase {
  ReminderManageBlocEvents get events;
  ReminderManageBlocStates get states;
}

/// [$ReminderManageBloc] extended by the [ReminderManageBloc]
/// {@nodoc}
abstract class $ReminderManageBloc extends RxBlocBase
    implements
        ReminderManageBlocEvents,
        ReminderManageBlocStates,
        ReminderManageBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [update]
  final _$updateEvent = PublishSubject<ReminderModel>();

  /// Тhe [Subject] where events sink to by calling [create]
  final _$createEvent = PublishSubject<_CreateEventArgs>();

  /// Тhe [Subject] where events sink to by calling [delete]
  final _$deleteEvent = PublishSubject<ReminderModel>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [onDeleted] implemented in [_mapToOnDeletedState]
  late final ConnectableStream<Result<ReminderModel>> _onDeletedState =
      _mapToOnDeletedState();

  /// The state of [onUpdated] implemented in [_mapToOnUpdatedState]
  late final ConnectableStream<Result<ReminderModel>> _onUpdatedState =
      _mapToOnUpdatedState();

  /// The state of [onCreated] implemented in [_mapToOnCreatedState]
  late final ConnectableStream<Result<ReminderModel>> _onCreatedState =
      _mapToOnCreatedState();

  @override
  void update(ReminderModel reminder) => _$updateEvent.add(reminder);

  @override
  void create(
          {required String title,
          required DateTime dueDate,
          required bool complete}) =>
      _$createEvent.add(
          _CreateEventArgs(title: title, dueDate: dueDate, complete: complete));

  @override
  void delete(ReminderModel reminder) => _$deleteEvent.add(reminder);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  ConnectableStream<Result<ReminderModel>> get onDeleted => _onDeletedState;

  @override
  ConnectableStream<Result<ReminderModel>> get onUpdated => _onUpdatedState;

  @override
  ConnectableStream<Result<ReminderModel>> get onCreated => _onCreatedState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  ConnectableStream<Result<ReminderModel>> _mapToOnDeletedState();

  ConnectableStream<Result<ReminderModel>> _mapToOnUpdatedState();

  ConnectableStream<Result<ReminderModel>> _mapToOnCreatedState();

  @override
  ReminderManageBlocEvents get events => this;

  @override
  ReminderManageBlocStates get states => this;

  @override
  void dispose() {
    _$updateEvent.close();
    _$createEvent.close();
    _$deleteEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [ReminderManageBlocEvents.create] event
class _CreateEventArgs {
  const _CreateEventArgs(
      {required this.title, required this.dueDate, required this.complete});

  final String title;

  final DateTime dueDate;

  final bool complete;
}
