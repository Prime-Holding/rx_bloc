{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/request_models/confirm_phone_number_request_model.dart';
import '../../models/request_models/phone_number_request_model.dart';
import '../../models/user_model.dart';

part 'users_remote_data_source.g.dart';

/// Used as a contractor for remote data source.
/// To make it work, should provide a real API and rerun build_runner
@RestApi()
abstract class UsersRemoteDataSource {
  factory UsersRemoteDataSource(Dio dio, {String baseUrl}) =
      _UsersRemoteDataSource;

  @PATCH('/api/users/me')
  Future<UserModel> submitPhoneNumber(
      @Body() PhoneNumberRequestModel phoneNumber);

  @POST('/api/users/me/phone/confirm')
  Future<UserModel> confirmPhoneNumber(
      @Body() ConfirmPhoneNumberRequestModel smsCode);

  @POST('/api/users/me/phone/resend')
  Future<void> resendSmsCode();
}
