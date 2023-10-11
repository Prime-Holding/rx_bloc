{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

enum AuthMatrixActionType {
  @JsonValue('PinOnly')
  pinOnly,
  @JsonValue('PinAndOtp')
  pinAndOtp,
  @JsonValue('None')
  none,
}
