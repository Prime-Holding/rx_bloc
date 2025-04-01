{{> licence.dart }}

import '../../base/models/user_model.dart';

sealed class CreatePinModel {}

class CreatePinSetModel extends CreatePinModel {}

class CreatePinConfirmModel extends CreatePinModel {
  final String pinToConfirm;

  CreatePinConfirmModel({
    required this.pinToConfirm,
  });
}

class CreatePinCompleteModel extends CreatePinModel {
  final UserModel user;

  CreatePinCompleteModel({required this.user});
}
