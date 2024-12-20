{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/request_models/phone_number_request_model.dart';
import '../../models/user_model.dart';

part 'users_remote_data_source.g.dart';

@RestApi()
abstract class UsersRemoteDataSource {
  factory UsersRemoteDataSource(Dio dio, {String baseUrl}) =
      _UsersRemoteDataSource;

  /// Gets the existing user. Currently used to resume onboarding
  @GET('/api/users/me')
  Future<UserModel> getMyUser();

  @PATCH('/api/users/me')
  Future<UserModel> submitPhoneNumber(
      @Body() PhoneNumberRequestModel phoneNumber);
}
