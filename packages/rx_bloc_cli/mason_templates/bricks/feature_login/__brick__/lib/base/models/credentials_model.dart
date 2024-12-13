{{> licence.dart }}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credentials_model.g.dart';

@JsonSerializable()
class CredentialsModel with EquatableMixin {
  CredentialsModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory CredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$CredentialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsModelToJson(this);

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
