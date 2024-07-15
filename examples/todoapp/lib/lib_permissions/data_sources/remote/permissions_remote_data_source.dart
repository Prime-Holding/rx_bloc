// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'permissions_remote_data_source.g.dart';

@RestApi()
abstract class PermissionsRemoteDataSource {
  factory PermissionsRemoteDataSource(Dio dio, {String baseUrl}) =
      _PermissionsRemoteDataSource;

  @GET('/api/permissions')
  Future<Map<String, bool>> getPermissions();
}
