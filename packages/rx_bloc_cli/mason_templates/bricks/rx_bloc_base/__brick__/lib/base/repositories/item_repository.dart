{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/items_remote_data_source.dart';
import '../models/item_model.dart';
import '../models/response_models/items_list_response_model.dart';

class ItemRepository {
  ItemRepository(
      this._itemsDataSource,
      this._errorMapper,
      );

  final ErrorMapper _errorMapper;
  final ItemsRemoteDataSource _itemsDataSource;

  Future<ItemsListResponseModel> fetchItems() =>
      _errorMapper.execute(() => _itemsDataSource.fetchItemsList());

  Future<ItemModel> fetchItemById({required String id}) =>
      _errorMapper.execute(() => _itemsDataSource.fetchItemById(id));
}
