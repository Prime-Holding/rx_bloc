// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'item_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ItemDetailsBlocType extends RxBlocTypeBase {
  ItemDetailsBlocEvents get events;
  ItemDetailsBlocStates get states;
}

/// [$ItemDetailsBloc] extended by the [ItemDetailsBloc]
/// {@nodoc}
abstract class $ItemDetailsBloc extends RxBlocBase
    implements
        ItemDetailsBlocEvents,
        ItemDetailsBlocStates,
        ItemDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchItemDetailsById]
  final _$fetchItemDetailsByIdEvent = BehaviorSubject<String>();

  /// Тhe [Subject] where events sink to by calling [showItemDetails]
  final _$showItemDetailsEvent = BehaviorSubject<ItemModel>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [item] implemented in [_mapToItemState]
  late final Stream<Result<ItemModel>> _itemState = _mapToItemState();

  @override
  void fetchItemDetailsById(String itemId) =>
      _$fetchItemDetailsByIdEvent.add(itemId);

  @override
  void showItemDetails(ItemModel item) => _$showItemDetailsEvent.add(item);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<Result<ItemModel>> get item => _itemState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<Result<ItemModel>> _mapToItemState();

  @override
  ItemDetailsBlocEvents get events => this;

  @override
  ItemDetailsBlocStates get states => this;

  @override
  void dispose() {
    _$fetchItemDetailsByIdEvent.close();
    _$showItemDetailsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
