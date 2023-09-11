{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'auth_matrix_cancel_model.g.dart';

@JsonSerializable()
class AuthMatrixCancelModel {
  AuthMatrixCancelModel(this.endToEndId, this.transactionId);

  final String endToEndId;
  final String transactionId;

  factory AuthMatrixCancelModel.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixCancelModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthMatrixCancelModelToJson(this);
}
