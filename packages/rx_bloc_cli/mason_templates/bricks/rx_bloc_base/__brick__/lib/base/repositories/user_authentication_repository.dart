// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../data_sources/remote/auth_data_source.dart';
import '../models/auth_token_model.dart';
import '../models/request_models/authenticate_user_request_model.dart';

class UserAuthRepository {
  UserAuthRepository(this._authDataSource);

  final AuthDataSource _authDataSource;

  Future<AuthTokenModel> authenticate(
          {String? email, String? password, String? refreshToken}) =>
      _authDataSource.authenticate(AuthUserRequestModel(
          username: email, password: password, refreshToken: refreshToken));

  Future<void> logout() => _authDataSource.logout();
}
