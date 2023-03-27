{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../lib_auth/models/auth_token_model.dart';
import '../models/apple_auth_request_model.dart';

part 'apple_auth_data_source.g.dart';

@RestApi()
abstract class AppleAuthDataSource {
  factory AppleAuthDataSource(Dio dio, {String baseUrl}) = _AppleAuthDataSource;

  @POST('/api/authenticate/apple')
  Future<AuthTokenModel> authenticate(@Body() AppleAuthRequestModel authData);
}
