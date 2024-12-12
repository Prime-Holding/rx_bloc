{{> licence.dart }}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../lib_auth/models/auth_token_model.dart';
import 'user_model.dart';

part 'user_with_auth_token_model.g.dart';

@CopyWith()
@JsonSerializable()
class UserWithAuthTokenModel with EquatableMixin {
  UserWithAuthTokenModel({
    required this.user,
    required this.authToken,
  });

  final UserModel user;
  final AuthTokenModel authToken;

  factory UserWithAuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$UserWithAuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserWithAuthTokenModelToJson(this);

  @override
  List<Object?> get props => [
        user,
        authToken,
      ];
}
