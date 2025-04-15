{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'confirmed_credentials_model.g.dart';

/// Model containing information of user confirmed credentials for the
/// onboarding process.
@JsonSerializable()
class ConfirmedCredentialsModel {
  ConfirmedCredentialsModel({
    required this.email,
    required this.phone,
  });

  /// Flag indicating whether the user has confirmed their email
  bool email;

  /// Flag indicating whether the user has confirmed their phone number
  bool phone;

  factory ConfirmedCredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmedCredentialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmedCredentialsModelToJson(this);

  ConfirmedCredentialsModel copyWith({
    bool? email,
    bool? phone,
  }) {
    return ConfirmedCredentialsModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() => toJson().toString();
}
