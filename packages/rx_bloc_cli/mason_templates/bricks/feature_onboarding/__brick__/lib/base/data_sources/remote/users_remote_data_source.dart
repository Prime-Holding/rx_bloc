{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/request_models/change_email_request_model.dart';
import '../../models/request_models/confirm_email_model.dart';
import '../../models/request_models/phone_number_request_model.dart';
import '../../models/user_model.dart';

part 'users_remote_data_source.g.dart';

@RestApi()
abstract class UsersRemoteDataSource {
  factory UsersRemoteDataSource(Dio dio, {String baseUrl}) =
      _UsersRemoteDataSource;

  /// Gets the existing user. Currently used to resume onboarding
  @GET('/api/users/me')
  Future<UserModel> getUser();

  @PATCH('/api/users/me')
  Future<UserModel> submitPhoneNumber(
      @Body() PhoneNumberRequestModel phoneNumber);

  /// Initiates the email change process with the new email
  @PATCH('/api/users/me/email')
  Future<UserModel> changeEmail(@Body() ChangeEmailRequestModel email);

  /// Confirms the new email of the user
  @POST('/api/users/me/email/confirm')
  Future<UserModel> confirmEmail(@Body() ConfirmEmailModel confirmEmailModel);
  
  /// Resends the confirmation email to the user
  @POST('/api/users/me/email/resend-confirmation')
  Future<UserModel> resendConfirmationEmail();
}
