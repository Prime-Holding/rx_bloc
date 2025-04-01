{{> licence.dart }}

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