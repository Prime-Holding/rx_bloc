abstract class MfaPayloadRequest {
  MfaPayloadRequest();

  Map<String, dynamic> toJson() => {...payloadToJson(), 'type': type};

  Map<String, dynamic> payloadToJson();

  /// The type of the payload.
  ///
  /// This is used to determine the type of the payload when deserializing.
  ///
  /// Usually it contains value either from from [MfaAction] or [MfaMethod] such as:
  /// - [MfaAction.changeAddress.name]
  /// - [MfaMethod.otp.name]
  String get type;
}
