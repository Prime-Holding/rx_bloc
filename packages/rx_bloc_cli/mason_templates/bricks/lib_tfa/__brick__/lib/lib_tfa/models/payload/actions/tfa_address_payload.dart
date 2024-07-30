import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../tfa_action.dart';
import '../tfa_payload_request.dart';

part 'tfa_address_payload.g.dart';

@CopyWith()
@JsonSerializable()
class TFAAddressPayload extends TFAPayloadRequest with EquatableMixin {
  TFAAddressPayload({
    required this.city,
    required this.streetAddress,
    required this.countryCode,
  });

  final String city;
  final String streetAddress;
  final String countryCode;

  @override
  String get type => TFAAction.changeAddress.name;

  @override
  List<Object?> get props => [city, streetAddress, countryCode, type];

  factory TFAAddressPayload.fromJson(Map<String, dynamic> json) =>
      _$TFAAddressPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$TFAAddressPayloadToJson(this);
}
