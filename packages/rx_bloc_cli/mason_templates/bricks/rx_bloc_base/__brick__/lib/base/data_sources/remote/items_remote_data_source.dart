{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/item_model.dart';
import '../../models/response_models/items_list_response_model.dart';

part 'items_remote_data_source.g.dart';

@RestApi()
abstract class ItemsRemoteDataSource {
  factory ItemsRemoteDataSource(Dio dio, {String baseUrl}) =
      _ItemsRemoteDataSource;

  @GET('/api/items')
  Future<ItemsListResponseModel> fetchItemsList();

  @GET('/api/item/{id}')
  Future<ItemModel> fetchItemById(
    @Path('id') String id,
  );
}
