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

{{#enable_feature_otp}}
extension CoordinatorConfirmedBinderExtensions on Stream<bool> {
  Stream<bool> emitOtpConfirmedToCoordinator(CoordinatorBlocType coordinator) =>
    doOnData(
      (isOtpConfirmed) => coordinator.events.confirmed(
        isOtpConfirmed: isOtpConfirmed,
      ),
    );
}{{/enable_feature_otp}}
