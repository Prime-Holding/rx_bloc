import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../mfa_action.dart';
import '../mfa_payload_request.dart';

part 'mfa_address_payload.g.dart';

@CopyWith()
@JsonSerializable()
class MfaAddressPayload extends MfaPayloadRequest with EquatableMixin {
  MfaAddressPayload({
    required this.city,
    required this.streetAddress,
    required this.countryCode,
  });

  final String city;
  final String streetAddress;
  final String countryCode;

  @override
  String get type => MfaAction.changeAddress.name;

  @override
  List<Object?> get props => [city, streetAddress, countryCode, type];

  factory MfaAddressPayload.fromJson(Map<String, dynamic> json) =>
      _$MfaAddressPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MfaAddressPayloadToJson(this);
}
