{{> licence.dart }}

import '../models/item_model.dart';
import '../repositories/item_repository.dart';

class ItemService {
  ItemService(
  this._itemRepository,
  );

  final ItemRepository _itemRepository;

  Future<List<ItemModel>> fetchItems() async {
    final result = await _itemRepository.fetchItems();
    return result.items;
  }

  Future<ItemModel> fetchItemById({required String id}) async {
    return await _itemRepository.fetchItemById(id: id);
  }
}
