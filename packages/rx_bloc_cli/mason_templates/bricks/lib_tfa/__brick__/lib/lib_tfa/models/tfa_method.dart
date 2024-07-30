import 'package:json_annotation/json_annotation.dart';

/// The method used to authenticate the user.
enum TFAMethod {
  /// The user needs to enter the PIN code or use biometric authentication.
  @JsonValue('PinBiometric')
  pinBiometric,

  /// The user needs to enter the OTP code usually received via SMS.
  @JsonValue('OTP')
  otp,

  /// The authentication process is complete.
  @JsonValue('None')
  complete,
}

extension TFAMethodX on TFAMethod {
  /// Convenient getter to check if the method is [TFAMethod.complete].
  bool get isComplete => this == TFAMethod.complete;
}
