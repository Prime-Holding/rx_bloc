{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../models/credentials_model.dart';
import '../../models/request_models/confirm_email_model.dart';
import '../../models/user_model.dart';
import '../../models/user_with_auth_token_model.dart';

part 'users_remote_data_source.g.dart';

@RestApi()
abstract class UsersRemoteDataSource {
  factory UsersRemoteDataSource(Dio dio, {String baseUrl}) =
      _UsersRemoteDataSource;

  @POST('/api/register')
  Future<UserWithAuthTokenModel> register(@Body() CredentialsModel credentials);

  @GET('/api/users/me')
  Future<UserModel> getMyUser();

  @POST('/api/users/me/email/resend-confirmation')
  Future<UserModel> resendConfirmationEmail();

  @POST('/api/users/me/email/confirm')
  Future<UserModel> confirmEmail(@Body() ConfirmEmailModel confirmEmailModel);
}
