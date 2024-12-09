{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'phone_number_request_model.g.dart';

@JsonSerializable()
class PhoneNumberRequestModel {
  PhoneNumberRequestModel({
    required this.phoneNumber,
  });

  final String phoneNumber;

  factory PhoneNumberRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$PhoneNumberRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberRequestModelToJson(this);
}
