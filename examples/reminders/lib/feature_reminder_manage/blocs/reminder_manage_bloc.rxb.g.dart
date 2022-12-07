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

  /// Тhe [Subject] where events sink to by calling [setName]
  final _$setNameEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [create]
  final _$createEvent = PublishSubject<_CreateEventArgs>();

  /// Тhe [Subject] where events sink to by calling [delete]
  final _$deleteEvent = PublishSubject<ReminderModel>();

  /// The state of [onDeleted] implemented in [_mapToOnDeletedState]
  late final ConnectableStream<Result<ReminderModel>> _onDeletedState =
      _mapToOnDeletedState();

  /// The state of [onUpdated] implemented in [_mapToOnUpdatedState]
  late final ConnectableStream<Result<ReminderPair>> _onUpdatedState =
      _mapToOnUpdatedState();

  /// The state of [onCreated] implemented in [_mapToOnCreatedState]
  late final ConnectableStream<Result<ReminderModel>> _onCreatedState =
      _mapToOnCreatedState();

  /// The state of [name] implemented in [_mapToNameState]
  late final Stream<String> _nameState = _mapToNameState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isFormValid] implemented in [_mapToIsFormValidState]
  late final Stream<bool> _isFormValidState = _mapToIsFormValidState();

  @override
  void update(ReminderModel reminder) => _$updateEvent.add(reminder);

  @override
  void setName(String title) => _$setNameEvent.add(title);

  @override
  void create({
    required DateTime dueDate,
    required bool complete,
  }) =>
      _$createEvent.add(_CreateEventArgs(
        dueDate: dueDate,
        complete: complete,
      ));

  @override
  void delete(ReminderModel reminder) => _$deleteEvent.add(reminder);

  @override
  ConnectableStream<Result<ReminderModel>> get onDeleted => _onDeletedState;

  @override
  ConnectableStream<Result<ReminderPair>> get onUpdated => _onUpdatedState;

  @override
  ConnectableStream<Result<ReminderModel>> get onCreated => _onCreatedState;

  @override
  Stream<String> get name => _nameState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isFormValid => _isFormValidState;

  ConnectableStream<Result<ReminderModel>> _mapToOnDeletedState();

  ConnectableStream<Result<ReminderPair>> _mapToOnUpdatedState();

  ConnectableStream<Result<ReminderModel>> _mapToOnCreatedState();

  Stream<String> _mapToNameState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsFormValidState();

  @override
  ReminderManageBlocEvents get events => this;

  @override
  ReminderManageBlocStates get states => this;

  @override
  void dispose() {
    _$updateEvent.close();
    _$setNameEvent.close();
    _$createEvent.close();
    _$deleteEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [ReminderManageBlocEvents.create] event
class _CreateEventArgs {
  const _CreateEventArgs({
    required this.dueDate,
    required this.complete,
  });

  final DateTime dueDate;

  final bool complete;
}
