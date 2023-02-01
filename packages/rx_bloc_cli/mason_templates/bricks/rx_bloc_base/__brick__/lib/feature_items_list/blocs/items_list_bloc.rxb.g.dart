// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'items_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ItemsListBlocType extends RxBlocTypeBase {
  ItemsListBlocEvents get events;
  ItemsListBlocStates get states;
}

/// [$ItemsListBloc] extended by the [ItemsListBloc]
/// {@nodoc}
abstract class $ItemsListBloc extends RxBlocBase
    implements ItemsListBlocEvents, ItemsListBlocStates, ItemsListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchItemsList]
  final _$fetchItemsListEvent = BehaviorSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [itemsList] implemented in [_mapToItemsListState]
  late final Stream<Result<List<ItemModel>>> _itemsListState =
      _mapToItemsListState();

  @override
  void fetchItemsList() => _$fetchItemsListEvent.add(null);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<Result<List<ItemModel>>> get itemsList => _itemsListState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<Result<List<ItemModel>>> _mapToItemsListState();

  @override
  ItemsListBlocEvents get events => this;

  @override
  ItemsListBlocStates get states => this;

  @override
  void dispose() {
    _$fetchItemsListEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
