{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'confirm_phone_number_request_model.g.dart';

@JsonSerializable()
class ConfirmPhoneNumberRequestModel {
  ConfirmPhoneNumberRequestModel({
    required this.smsCode,
  });

  final String smsCode;

  factory ConfirmPhoneNumberRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPhoneNumberRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConfirmPhoneNumberRequestModelToJson(this);
}
