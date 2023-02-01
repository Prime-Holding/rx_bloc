{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/item_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/item_model.dart';

part 'items_list_bloc.rxb.g.dart';

/// A contract class containing all events of the ItemsListBloC.
abstract class ItemsListBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void fetchItemsList();
}

/// A contract class containing all states of the ItemsListBloC.
abstract class ItemsListBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  Stream<Result<List<ItemModel>>> get itemsList;
}

@RxBloc()
class ItemsListBloc extends $ItemsListBloc {
  ItemsListBloc(this._itemService) {
    fetchItemsList();
  }

  final ItemService _itemService;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<List<ItemModel>>> _mapToItemsListState() =>
      _$fetchItemsListEvent
          .switchMap((_) => _itemService.fetchItems().asResultStream())
          .shareReplay(maxSize: 1);
}
