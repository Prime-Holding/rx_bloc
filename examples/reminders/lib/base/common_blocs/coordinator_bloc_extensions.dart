// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<Result<bool>> {
  /// Conveneince method to emit the authentication state to the coordinator
  /// bloc once it has been signaled that the user has logged in
  Stream<bool> emitLoggedInToCoordinator(CoordinatorBlocType coordinator) =>
      whereSuccess().where((hasLoggedIn) => hasLoggedIn).doOnData(
            (hasLoggedIn) => coordinator.events.authenticated(
              isAuthenticated: hasLoggedIn,
            ),
          );

  /// Conveneince method to emit the authentication state to the coordinator
  /// bloc once it has been signaled that the user has logged out
  Stream<bool> emitLoggedOutToCoordinator(CoordinatorBlocType coordinator) =>
      whereSuccess().where((hasLoggedOut) => hasLoggedOut).doOnData(
            (hasLoggedOut) => coordinator.events.authenticated(
              isAuthenticated: !hasLoggedOut,
            ),
          );
}
