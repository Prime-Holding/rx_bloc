// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<Result<bool>> {
  Stream<bool> emitLoggedInToCoordinator(CoordinatorBlocType coordinator) =>
      whereSuccess().where((hasLoggedIn) => hasLoggedIn).doOnData(
            (hasLoggedIn) => coordinator.events.authenticated(
              isAuthenticated: hasLoggedIn,
            ),
          );

  Stream<bool> emitLoggedOutToCoordinator(CoordinatorBlocType coordinator) =>
      whereSuccess().where((hasLoggedOut) => hasLoggedOut).doOnData(
            (hasLoggedOut) => coordinator.events.authenticated(
              isAuthenticated: !hasLoggedOut,
            ),
          );
}
