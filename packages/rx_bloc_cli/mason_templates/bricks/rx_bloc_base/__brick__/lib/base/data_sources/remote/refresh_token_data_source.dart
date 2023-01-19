import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/auth_token_model.dart';
import '../../models/request_models/authenticate_user_request_model.dart';

part 'refresh_token_data_source.g.dart';

// This data source is used for refreshing the access token using the given
// refresh token. It is implemented as a separate data source so that it can use
// a dedicated HTTP client and not block the main one using the
// QueuedInterceptor.

@RestApi()
abstract class RefreshTokenDataSource {
  factory RefreshTokenDataSource(Dio dio, {String baseUrl}) =
      _RefreshTokenDataSource;

  @POST('/api/authenticate')
  Future<AuthTokenModel> refresh(@Body() AuthUserRequestModel refreshToken);
}
