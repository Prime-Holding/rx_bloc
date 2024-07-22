import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../auth_matrix_action.dart';
import '../auth_matrix_payload_request.dart';

part 'auth_matrix_address_payload.g.dart';

@CopyWith()
@JsonSerializable()
class AuthMatrixAddressPayload extends AuthMatrixPayloadRequest
    with EquatableMixin {
  AuthMatrixAddressPayload({
    required this.city,
    required this.streetAddress,
    required this.countryCode,
  });

  final String city;
  final String streetAddress;
  final String countryCode;

  @override
  String get type => AuthMatrixAction.changeAddress.name;

  @override
  List<Object?> get props => [city, streetAddress, countryCode, type];

  factory AuthMatrixAddressPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixAddressPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$AuthMatrixAddressPayloadToJson(this);
}
