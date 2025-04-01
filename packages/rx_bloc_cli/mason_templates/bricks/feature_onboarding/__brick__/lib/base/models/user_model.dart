{{> licence.dart }}

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
    required this.hasPin,
  });

  /// Unique identifier of the user
  final String id;

  /// Email address
  final String email;

  /// Phone number including the country code
  final String? phoneNumber;

  /// Type of user account indicating the registration status.
  ///
  /// If a user account is created but not yet confirmed, the role will be
  /// set to `TempUser`. Once the user confirms account details, the role
  /// is updated to `User`.
  final UserRole role;

  /// Flag indicating whether the user has set a PIN code
  final bool hasPin;

  /// Information about the confirmed credentials of the user
  final ConfirmedCredentialsModel confirmedCredentials;


  factory UserModel.tempUser() => UserModel(
        id: '',
        email: '',
        phoneNumber: '',
        role: UserRole.tempUser,
        confirmedCredentials: ConfirmedCredentialsModel(
          email: false,
          phone: false,
        ),
        hasPin: false,
      );
      
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

  @override
  String toString() => toJson().toString();
}
