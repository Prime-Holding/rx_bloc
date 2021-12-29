// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import '../repositories/auth_repository.dart';

/// Returns access token, if is saved, by default.
class FetchAccessTokenUseCase {
  FetchAccessTokenUseCase(
    this._authRepository,
  );

  final AuthRepository _authRepository;

  /// If you want to get refresh token, you should set forceFetchNewToken to true
  Future<String?> execute({bool forceFetchNewToken = false}) async {
    if (!forceFetchNewToken) {
      final token = await _authRepository.getToken();
      if (token != null) {
        return token;
      }
    }
    final refreshToken = await _authRepository.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();
    return newToken;
  }
}
