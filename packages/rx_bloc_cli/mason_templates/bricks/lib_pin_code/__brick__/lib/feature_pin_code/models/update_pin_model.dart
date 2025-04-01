{{> licence.dart }}

import '../../base/models/user_model.dart';

sealed class UpdatePinModel {}

class UpdatePinVerifyModel extends UpdatePinModel {}

class UpdatePinSetModel extends UpdatePinModel {
  final String token;

  UpdatePinSetModel({required this.token});
}

class UpdatePinConfirmModel extends UpdatePinModel {
  final String pinToConfirm;
  final String token;

  UpdatePinConfirmModel({
    required this.pinToConfirm,
    required this.token,
  });
}

class UpdatePinCompleteModel extends UpdatePinModel {
  final UserModel user;

  UpdatePinCompleteModel({required this.user});
}
