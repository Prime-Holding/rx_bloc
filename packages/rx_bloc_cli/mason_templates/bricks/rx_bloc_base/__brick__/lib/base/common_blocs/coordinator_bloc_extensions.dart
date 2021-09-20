{{> licence.dart }}

part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<Result<bool>> {
  Stream<bool> emitLoggedInToCoordinator(CoordinatorBlocType coordinator) =>
      whereSuccess().where((hasLoggedOut) => hasLoggedOut).doOnData(
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
