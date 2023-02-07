{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/item_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/item_model.dart';

part 'item_details_bloc.rxb.g.dart';

/// A contract class containing all events of the ItemDetailsBloC.
abstract class ItemDetailsBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void fetchItemDetailsById(String itemId);

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void showItemDetails(ItemModel item);
}

/// A contract class containing all states of the ItemDetailsBloC.
abstract class ItemDetailsBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  Stream<Result<ItemModel>> get item;
}

@RxBloc()
class ItemDetailsBloc extends $ItemDetailsBloc {
  ItemDetailsBloc(
    this._itemService, {
    required String itemId,
    ItemModel? item,
  }) {
    initItemDetailsData(
      itemId: itemId,
      item: item,
    );
  }

  final ItemService _itemService;

  void initItemDetailsData({required String itemId, ItemModel? item}) {
    if (item != null) {
      showItemDetails(item);
    } else {
      fetchItemDetailsById(itemId);
    }
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<ItemModel>> _mapToItemState() => Rx.merge([
        _$fetchItemDetailsByIdEvent
            .switchMap((itemId) =>
                _itemService.fetchItemById(id: itemId).asResultStream()),
        _$showItemDetailsEvent
            .mapToResult((item) => item),
      ]).setResultStateHandler(this).shareReplay(maxSize: 1);
}
