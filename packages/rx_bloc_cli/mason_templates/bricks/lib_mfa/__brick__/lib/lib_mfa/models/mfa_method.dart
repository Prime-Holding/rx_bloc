import 'package:json_annotation/json_annotation.dart';

/// The method used to authenticate the user.
enum MFAMethod {
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

extension MFAMethodX on MFAMethod {
  /// Convenient getter to check if the method is [MFAMethod.complete].
  bool get isComplete => this == MFAMethod.complete;
}
