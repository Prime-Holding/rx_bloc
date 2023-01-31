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
  void getItemsList();
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
  ItemsListBloc(ItemService itemService) {
    _$getItemsListEvent
        .startWith(null)
        .switchMap((_) => itemService.fetchItems().asResultStream())
        .bind(_itemsListSubject)
        .addTo(_compositeSubscription);
  }

  final _itemsListSubject =
  BehaviorSubject<Result<List<ItemModel>>>.seeded(Result.loading());

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<List<ItemModel>>> _mapToItemsListState() => _itemsListSubject;

  @override
  void dispose() {
    _itemsListSubject.close();
    super.dispose();
  }
}
