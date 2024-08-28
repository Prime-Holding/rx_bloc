import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pin_code_create_request.g.dart';

@JsonSerializable()
@CopyWith()
class PinCodeCreateRequest with EquatableMixin {
  PinCodeCreateRequest({
    required this.pinCode,
  });

  final String pinCode;

  factory PinCodeCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PinCodeCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PinCodeCreateRequestToJson(this);

  @override
  List<Object?> get props => [pinCode];

  @override
  bool? get stringify => true;
}
