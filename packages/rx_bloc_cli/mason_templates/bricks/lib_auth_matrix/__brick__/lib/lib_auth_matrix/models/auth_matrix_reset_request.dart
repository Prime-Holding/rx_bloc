import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_matrix_reset_request.g.dart';

@JsonSerializable()
@CopyWith()
class AuthMatrixResetRequest with EquatableMixin {
  AuthMatrixResetRequest({
    required this.securityToken,
  });

  /// The security token used to authenticate the user and authorize the request.
  final String securityToken;

  factory AuthMatrixResetRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixResetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMatrixResetRequestToJson(this);

  @override
  List<Object?> get props => [securityToken];

  @override
  bool? get stringify => true;
}
