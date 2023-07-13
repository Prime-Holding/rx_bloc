{{> licence.dart }}

part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<bool> {
  Stream<bool> emitAuthenticatedToCoordinator(
          CoordinatorBlocType coordinator) =>
      doOnData(
        (isAuthenticated) => coordinator.events.authenticated(
          isAuthenticated: isAuthenticated,
        ),
      ); {{#enable_pin_code}}
Stream<bool> emitPinCodeConfirmedToCoordinator(
CoordinatorBlocType coordinator) =>
doOnData((isPinCodeConfirmed) {
return coordinator.events.pinCodeConfirmed(
isPinCodeConfirmed: isPinCodeConfirmed,
);
});{{/enable_pin_code}}
}

{{#enable_feature_otp}}
extension CoordinatorConfirmedBinderExtensions on Stream<bool> {
  Stream<bool> emitOtpConfirmedToCoordinator(CoordinatorBlocType coordinator) =>
    doOnData(
      (isOtpConfirmed) => coordinator.events.otpConfirmed(
        isOtpConfirmed: isOtpConfirmed,
      ),
    );
}{{/enable_feature_otp}}
