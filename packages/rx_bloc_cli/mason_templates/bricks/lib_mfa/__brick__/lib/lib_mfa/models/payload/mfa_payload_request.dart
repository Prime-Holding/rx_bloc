abstract class MFAPayloadRequest {
  MFAPayloadRequest();

  Map<String, dynamic> toJson() => {...payloadToJson(), 'type': type};

  Map<String, dynamic> payloadToJson();

  /// The type of the payload.
  ///
  /// This is used to determine the type of the payload when deserializing.
  ///
  /// Usually it contains value either from from [MFAAction] or [MFAMethod] such as:
  /// - [MFAAction.changeAddress.name]
  /// - [MFAMethod.otp.name]
  String get type;
}
