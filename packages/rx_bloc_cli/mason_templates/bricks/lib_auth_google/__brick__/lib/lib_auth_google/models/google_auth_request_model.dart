import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class GoogleAuthRequestModel {
  final String? displayName;
  final String email;
  final String id;
  final String? photoUrl;
  final String? serverAuthCode;

  GoogleAuthRequestModel({
    this.displayName,
    required this.email,
    required this.id,
    this.photoUrl,
    this.serverAuthCode,
  });
  factory GoogleAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAuthRequestModelToJson(this);
}
