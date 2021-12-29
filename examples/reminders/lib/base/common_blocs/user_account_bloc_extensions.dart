// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


part of 'user_account_bloc.dart';

extension _LogingOutExtensions on Stream<void> {
  Stream<Result<bool>> logoutUser(LogoutUseCase useCase) =>
      throttleTime(const Duration(seconds: 1))
          .switchMap((value) => useCase.execute().asResultStream());
}
