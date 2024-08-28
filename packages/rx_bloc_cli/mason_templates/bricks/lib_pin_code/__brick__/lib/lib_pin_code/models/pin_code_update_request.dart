import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pin_code_update_request.g.dart';

@JsonSerializable()
@CopyWith()
class PinCodeUpdateRequest with EquatableMixin {
  PinCodeUpdateRequest({
    required this.pinCode,
    required this.token,
  });

  final String pinCode;
  final String token;

  factory PinCodeUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$PinCodeUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PinCodeUpdateRequestToJson(this);

  @override
  List<Object?> get props => [pinCode, token];

  @override
  bool? get stringify => true;
}
