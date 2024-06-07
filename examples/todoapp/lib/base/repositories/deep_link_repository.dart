// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/deep_link_remote_data_source.dart';
import '../models/deep_link_model.dart';
import '../models/response_models/deep_link_list_response_model.dart';

class DeepLinkRepository {
  DeepLinkRepository(
    this._deepLinkRemoteDataSource,
    this._errorMapper,
  );

  final ErrorMapper _errorMapper;
  final DeepLinkRemoteDataSource _deepLinkRemoteDataSource;

  Future<DeepLinkListResponseModel> fetchDeepLinks() =>
      _errorMapper.execute(() => _deepLinkRemoteDataSource.fetchDeepLinkList());

  Future<DeepLinkModel> fetchDeepLinkById({required String id}) => _errorMapper
      .execute(() => _deepLinkRemoteDataSource.fetchDeepLinkById(id));
}
