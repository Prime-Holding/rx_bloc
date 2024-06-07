// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/deep_link_model.dart';
import '../../models/response_models/deep_link_list_response_model.dart';

part 'deep_link_remote_data_source.g.dart';

@RestApi()
abstract class DeepLinkRemoteDataSource {
  factory DeepLinkRemoteDataSource(Dio dio, {String baseUrl}) =
      _DeepLinkRemoteDataSource;

  @GET('/api/deep-links')
  Future<DeepLinkListResponseModel> fetchDeepLinkList();

  @GET('/api/deep-links/{id}')
  Future<DeepLinkModel> fetchDeepLinkById(
    @Path('id') String id,
  );
}
