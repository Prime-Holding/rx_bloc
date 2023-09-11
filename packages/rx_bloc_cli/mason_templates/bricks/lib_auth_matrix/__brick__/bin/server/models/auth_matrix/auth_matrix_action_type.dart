{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'action')
enum AuthMatrixActionType {
  pinOnly('PinOnly'),
  pinAndOtp('PinAndOtp'),
  none('None');

  const AuthMatrixActionType(this.action);
  final String action;

  static AuthMatrixActionType toAuthMatrixActionType(String action) =>
      AuthMatrixActionType.values.firstWhere(
        (element) => element.action == action,
      );
}
