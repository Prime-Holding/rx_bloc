{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../lib_auth/models/auth_token_model.dart';
import '../models/facebook_auth_request_model.dart';

part 'facebook_auth_data_source.g.dart';

@RestApi()
abstract class FacebookAuthDataSource {
  factory FacebookAuthDataSource(Dio dio, {String baseUrl}) =
  _FacebookAuthDataSource;

  @POST('/api/authenticate/facebook')
  Future<AuthTokenModel> facebookAuthenticate(
      @Body() FacebookAuthRequestModel authData);
}
