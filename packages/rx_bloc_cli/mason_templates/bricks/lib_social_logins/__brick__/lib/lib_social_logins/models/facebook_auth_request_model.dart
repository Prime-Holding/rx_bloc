import 'package:json_annotation/json_annotation.dart';

part 'facebook_auth_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FacebookAuthRequestModel {
  final String email;
  final String facebookToken;
  final bool isAuthenticated;
  final String name;
  final String? userPictureUrl;
  final DateTime? userBirthday;
  final bool? publicProfile;
  final String? userGender;
  final String? userLink;

  FacebookAuthRequestModel(
      {required this.name,
      this.userPictureUrl,
      this.userBirthday,
      this.publicProfile,
      this.userGender,
      this.userLink,
      required this.email,
      required this.facebookToken,
      required this.isAuthenticated});
  factory FacebookAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FacebookAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$FacebookAuthRequestModelToJson(this);
}
