// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'reminder_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class ReminderListBlocType extends RxBlocTypeBase {
  ReminderListBlocEvents get events;
  ReminderListBlocStates get states;
}

/// [$ReminderListBloc] extended by the [ReminderListBloc]
/// @nodoc
abstract class $ReminderListBloc extends RxBlocBase
    implements
        ReminderListBlocEvents,
        ReminderListBlocStates,
        ReminderListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<bool>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [paginatedList] implemented in [_mapToPaginatedListState]
  late final Stream<PaginatedList<ReminderModel>> _paginatedListState =
      _mapToPaginatedListState();

  @override
  void loadPage({bool reset = false}) => _$loadPageEvent.add(reset);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<PaginatedList<ReminderModel>> get paginatedList => _paginatedListState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<PaginatedList<ReminderModel>> _mapToPaginatedListState();

  @override
  ReminderListBlocEvents get events => this;

  @override
  ReminderListBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
