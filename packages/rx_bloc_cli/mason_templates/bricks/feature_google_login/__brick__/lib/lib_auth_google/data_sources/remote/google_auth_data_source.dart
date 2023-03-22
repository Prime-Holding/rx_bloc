// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../lib_auth/models/auth_token_model.dart';
import '../../models/google_auth_request_model.dart';

part 'google_auth_data_source.g.dart';

@RestApi()
abstract class GoogleAuthDataSource {
  factory GoogleAuthDataSource(Dio dio, {String baseUrl}) =
      _GoogleAuthDataSource;

  @POST('/api/authenticate/google')
  Future<AuthTokenModel> googleAuth(@Body() GoogleAuthRequestModel authData);
}
