enum AuthMatrixPayloadResponseType { lastLogin }

abstract class AuthMatrixPayloadResponse {
  AuthMatrixPayloadResponse();

  Map<String, dynamic> toJson() => {...payloadToJson(), 'type': type.name};

  Map<String, dynamic> payloadToJson();

  /// The type of the payload.
  ///
  /// This is used to determine the type of the payload when deserializing.
  AuthMatrixPayloadResponseType get type;
}
