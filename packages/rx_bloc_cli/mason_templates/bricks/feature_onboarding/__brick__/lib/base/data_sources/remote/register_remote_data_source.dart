{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/credentials_model.dart';
import '../../models/request_models/confirm_email_model.dart';
import '../../models/request_models/confirm_phone_number_request_model.dart';
import '../../models/user_model.dart';
import '../../models/user_with_auth_token_model.dart';

part 'register_remote_data_source.g.dart';

@RestApi()
abstract class RegisterRemoteDataSource {
  factory RegisterRemoteDataSource(Dio dio, {String baseUrl}) =
      _RegisterRemoteDataSource;

  /// Starts the onboarding for a new user with the given [email] and [password].
  /// Returns the [UserModel] with the email and temporary profile, as well as
  /// their access token
  @POST('/api/register')
  Future<UserWithAuthTokenModel> register(@Body() CredentialsModel credentials);

  /// Resends the confirmation email to the user
  @POST('/api/register/email/resend-confirmation')
  Future<UserModel> resendConfirmationEmail();

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  @POST('/api/register/email/confirm')
  Future<UserModel> confirmEmail(@Body() ConfirmEmailModel confirmEmailModel);

  /// Confirms the phone number for the user by providing the SMS code sent to
  /// the user's phone number.
  @POST('/api/register/phone/confirm')
  Future<UserModel> confirmPhoneNumber(
      @Body() ConfirmPhoneNumberRequestModel smsCode);

  /// Resends the SMS code to the user's phone number
  @POST('/api/register/phone/resend')
  Future<void> resendSmsCode();
}
