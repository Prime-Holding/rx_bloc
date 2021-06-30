// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/auth_token_model.dart';
import '../../models/request_models/authenticate_user_request_model.dart';

part 'auth_data_source.g.dart';

@RestApi(baseUrl: 'http://0.0.0.0:8080')
abstract class AuthDataSource {
  factory AuthDataSource(Dio dio, {String baseUrl}) = _AuthDataSource;

  @POST('/api/authenticate')
  Future<AuthTokenModel> authenticate(@Body() AuthUserRequestModel authData);

  @POST('/api/logout')
  Future<void> logout();
}
