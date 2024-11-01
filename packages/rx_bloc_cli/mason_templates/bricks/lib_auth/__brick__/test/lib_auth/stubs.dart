import 'package:{{project_name}}/lib_auth/models/auth_token_model.dart';

class Stubs{
  static const email = 'someone@email.com';

  static const password = 'secret';

  static const authToken = 'sometoken';

  static const refreshToken = 'somerefreshtoken';

  static final authTokenModel = AuthTokenModel(authToken, refreshToken);
}