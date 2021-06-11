// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/repositories/auth_repository.dart';

class LogoutUseCase{
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> execute() async {
    // TODO Add your logic for logging out here
      await _authRepository.clearAuthData();
  }

}