import 'package:json_annotation/json_annotation.dart';

part 'facebook_auth_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FacebookAuthRequestModel {
  final String? email;
  final String? facebookToken;
  final bool isAuthenticated;

  FacebookAuthRequestModel(
      {this.email, this.facebookToken, required this.isAuthenticated});
  factory FacebookAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FacebookAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$FacebookAuthRequestModelToJson(this);
}
