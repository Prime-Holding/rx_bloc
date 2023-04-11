{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../lib_auth/models/auth_token_model.dart';
import '../models/google_auth_request_model.dart';

part 'google_auth_data_source.g.dart';

@RestApi()
abstract class GoogleAuthDataSource {
  factory GoogleAuthDataSource(Dio dio, {String baseUrl}) =
      _GoogleAuthDataSource;

  @POST('/api/authenticate/google')
  Future<AuthTokenModel> googleAuth(
      @Body() GoogleAuthRequestModel googleAuthRequestModel);
}
