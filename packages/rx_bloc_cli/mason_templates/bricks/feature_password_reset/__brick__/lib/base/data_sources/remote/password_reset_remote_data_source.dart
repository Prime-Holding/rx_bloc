{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/request_models/password_reset_init_request_model.dart';
import '../../models/request_models/password_reset_request_model.dart';

part 'password_reset_remote_data_source.g.dart';

@RestApi()
abstract class PasswordResetRemoteDataSource {
  factory PasswordResetRemoteDataSource(Dio dio, {String baseUrl}) =
      _PasswordResetRemoteDataSource;

  @POST('/api/password-reset/request')
  Future<void> requestPasswordReset(
      @Body() PasswordResetInitRequestModel request);

  @POST('/api/password-reset/confirm')
  Future<void> resetPassword(@Body() PasswordResetRequestModel passwordReset);
}
