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

  /// Starts the onboarding for a new user with the given [email] and [password].
  /// Returns the [UserModel] with the email and temporary profile, as well as
  /// their access token
  @POST('/api/register')
  Future<UserWithAuthTokenModel> register(@Body() CredentialsModel credentials);

  /// Gets the existing user. Currently used to resume onboarding
  @GET('/api/users/me')
  Future<UserModel> getMyUser();

  /// Resends the confirmation email to the user
  @POST('/api/users/me/email/resend-confirmation')
  Future<UserModel> resendConfirmationEmail();

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  @POST('/api/users/me/email/confirm')
  Future<UserModel> confirmEmail(@Body() ConfirmEmailModel confirmEmailModel);
}
