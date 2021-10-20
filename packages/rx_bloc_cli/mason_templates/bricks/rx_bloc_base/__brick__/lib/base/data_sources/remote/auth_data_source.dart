{{> licence.dart }}

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
