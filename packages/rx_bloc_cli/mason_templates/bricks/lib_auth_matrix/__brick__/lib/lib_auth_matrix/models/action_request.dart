{{> licence.dart }}

import 'auth_matrix_action_type.dart';

abstract class ActionRequest {
  ActionRequest(this.action, this.endToEndId);
  final AuthMatrixActionType action;
  final String endToEndId;

  Map<String, dynamic> toJson();
}
