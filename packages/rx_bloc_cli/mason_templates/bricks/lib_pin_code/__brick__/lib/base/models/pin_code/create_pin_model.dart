{{> licence.dart }}

import '../user_model.dart';

/// A sealed class representing the base model for creating a PIN.
sealed class CreatePinModel {}

/// A model representing the state where a PIN is being set.
class CreatePinSetModel extends CreatePinModel {}

/// A model representing the state where a PIN is being confirmed.
///
/// This class contains the [pinToConfirm] property, which holds the PIN
/// that needs to be confirmed.
class CreatePinConfirmModel extends CreatePinModel {
  /// The PIN that needs to be confirmed.
  final String pinToConfirm;

  CreatePinConfirmModel({
    required this.pinToConfirm,
  });
}

/// A model representing the state where the PIN creation process is complete.
///
/// This class contains the [user] property, which holds the user information
/// associated with the completed PIN creation.
class CreatePinCompleteModel extends CreatePinModel {
  /// The user information associated with the completed PIN creation.
  final UserModel user;

  CreatePinCompleteModel({required this.user});
}
