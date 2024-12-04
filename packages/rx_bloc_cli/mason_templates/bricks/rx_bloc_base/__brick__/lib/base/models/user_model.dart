import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'confirmed_credentials_model.dart';
import 'user_role.dart';

part 'user_model.g.dart';

@CopyWith()
@JsonSerializable()
class UserModel with EquatableMixin {
  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.confirmedCredentials,
  });

  final String id;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final ConfirmedCredentialsModel confirmedCredentials;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        role,
        confirmedCredentials,
      ];
}
