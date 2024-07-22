abstract class AuthMatrixPayloadRequest {
  AuthMatrixPayloadRequest();

  Map<String, dynamic> toJson() => {...payloadToJson(), 'type': type};

  Map<String, dynamic> payloadToJson();

  /// The type of the payload.
  ///
  /// This is used to determine the type of the payload when deserializing.
  ///
  /// Usually it contains value either from from [AuthMatrixAction] or [AuthMatrixMethod] such as:
  /// - [AuthMatrixAction.changeAddress.name]
  /// - [AuthMatrixMethod.otp.name]
  String get type;
}
