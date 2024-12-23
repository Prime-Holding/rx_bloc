{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'confirm_email_model.g.dart';

@JsonSerializable()
class ConfirmEmailModel {
  ConfirmEmailModel(this.token);

  /// The token used to confirm the user's email
  final String token;

  factory ConfirmEmailModel.fromJson(Map<String, dynamic> json) =>
  _$ConfirmEmailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmEmailModelToJson(this);
}
