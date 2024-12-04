import 'package:json_annotation/json_annotation.dart';

part 'confirmed_credentials_model.g.dart';

@JsonSerializable()
class ConfirmedCredentialsModel {
  ConfirmedCredentialsModel({required this.email, required this.phone});

  bool email;
  bool phone;

  factory ConfirmedCredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmedCredentialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmedCredentialsModelToJson(this);
}
