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
  void getItemDetails(String itemId);
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
      }) : _itemSubject = BehaviorSubject<Result<ItemModel>>.seeded(
      item != null ? Result.success(item) : Result.loading()) {
    initItemData(itemId);
  }

  final ItemService _itemService;

  final BehaviorSubject<Result<ItemModel>> _itemSubject;

  void initItemData(String itemId) {
    _$getItemDetailsEvent
        .startWith('')
        .where((_) => _itemSubject.value is! ResultSuccess)
        .switchMap(
            (value) => _itemService.fetchItemById(id: itemId).asResultStream())
        .bind(_itemSubject)
        .addTo(_compositeSubscription);
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<ItemModel>> _mapToItemState() => _itemSubject;

  @override
  void dispose() {
    _itemSubject.close();
    super.dispose();
  }
}
