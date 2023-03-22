import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class GoogleAuthRequestModel {
  final String? email;
  final String? token;
  final String? refreshToken;

  GoogleAuthRequestModel({this.refreshToken, this.email, this.token});
  factory GoogleAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAuthRequestModelToJson(this);
}
