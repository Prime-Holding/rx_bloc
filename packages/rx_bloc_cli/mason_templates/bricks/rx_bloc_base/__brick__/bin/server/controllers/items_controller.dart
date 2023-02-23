{{> licence.dart }}

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/item_model.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class ItemsController extends ApiController {
  final _items = [
    ItemModel(
      id: '1',
      name: 'Item 1',
      description: 'Short description for Item 1',
    ),
    ItemModel(
      id: '2',
      name: 'Item 2',
      description: 'Short description for Item 2',
    ),
    ItemModel(
      id: '3',
      name: 'Item 3',
      description: 'Short description for Item 3',
    ),
  ];

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/items',
      itemsListHandler,
    );

    router.addRequest(
      RequestType.GET,
      '/api/item/<id>',
      itemByIdHandler,
    );
  }

  Response itemsListHandler(Request request) {
    return responseBuilder.buildOK(data: {
      'items': _items,
    });
  }

  Response itemByIdHandler(Request request) {
    final result =
        _items.firstWhereOrNull((item) => item.id == request.params['id']);
    if (result == null) {
      throw NotFoundException(
          'Item with id: ${request.params['id']} is not found.');
    }
    return responseBuilder.buildOK(data: result.toJson());
  }
}
