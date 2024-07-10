// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<bool> {
  Stream<bool> emitAuthenticatedToCoordinator(
          CoordinatorBlocType coordinator) =>
      doOnData(
        (isAuthenticated) => coordinator.events.authenticated(
          isAuthenticated: isAuthenticated,
        ),
      );
}
