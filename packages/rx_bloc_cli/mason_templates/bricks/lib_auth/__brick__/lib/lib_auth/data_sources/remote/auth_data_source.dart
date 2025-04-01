{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../base/models/user_model.dart';
import '../../../base/models/user_with_auth_token_model.dart';
import '../../models/request_models/authenticate_user_request_model.dart';

part 'auth_data_source.g.dart';

@RestApi()
abstract class AuthDataSource {
  factory AuthDataSource(Dio dio, {String baseUrl}) = _AuthDataSource;

  @POST('/api/authenticate')
  Future<UserWithAuthTokenModel> authenticate(
      @Body() AuthUserRequestModel authData);

  @POST('/api/logout')
  Future<void> logout();

  @GET('/api/users/me')
  Future<UserModel> getCurrentUser();
}
