abstract class TFAPayloadRequest {
  TFAPayloadRequest();

  Map<String, dynamic> toJson() => {...payloadToJson(), 'type': type};

  Map<String, dynamic> payloadToJson();

  /// The type of the payload.
  ///
  /// This is used to determine the type of the payload when deserializing.
  ///
  /// Usually it contains value either from from [TFAAction] or [TFAMethod] such as:
  /// - [TFAAction.changeAddress.name]
  /// - [TFAMethod.otp.name]
  String get type;
}
