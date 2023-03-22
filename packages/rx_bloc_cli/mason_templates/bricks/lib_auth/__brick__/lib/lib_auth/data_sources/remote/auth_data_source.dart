{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

{{#enable_feature_google_login}}
import '../../../feature_login/models/request_models/google_auth_request_model.dart';
{{/enable_feature_google_login}}
import '../../models/auth_token_model.dart';
import '../../models/request_models/authenticate_user_request_model.dart';

part 'auth_data_source.g.dart';

@RestApi()
abstract class AuthDataSource {
  factory AuthDataSource(Dio dio, {String baseUrl}) = _AuthDataSource;

  @POST('/api/authenticate')
  Future<AuthTokenModel> authenticate(@Body() AuthUserRequestModel authData);

  @POST('/api/logout')
  Future<void> logout();
  {{#enable_feature_google_login}}
  @POST('/api/authenticate/google')
  Future<AuthTokenModel> googleAuth(@Body() GoogleAuthRequestModel authData);
  {{/enable_feature_google_login}}
}
