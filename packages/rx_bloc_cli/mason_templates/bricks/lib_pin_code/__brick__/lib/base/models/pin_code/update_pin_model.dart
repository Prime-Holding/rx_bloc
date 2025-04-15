{{> licence.dart }}

import '../user_model.dart';

/// A sealed class representing the base model for updating a PIN.
sealed class UpdatePinModel {}

/// A model representing the verification step in the PIN update process.
class UpdatePinVerifyModel extends UpdatePinModel {}

/// A model representing the setting of a new PIN in the update process.
///
/// Contains a [token] required for authentication or validation.
class UpdatePinSetModel extends UpdatePinModel {
  /// Creates an instance of [UpdatePinSetModel].
  ///
  /// The [token] parameter is required and must not be null.
  UpdatePinSetModel({required this.token});

  /// The token used for authentication or validation during the PIN update process.
  final String token;
}

/// A model representing the confirmation of a new PIN in the update process.
///
/// Contains the [pinToConfirm] and [token] required for validation.
class UpdatePinConfirmModel extends UpdatePinModel {
  /// Creates an instance of [UpdatePinConfirmModel].
  ///
  /// Both [pinToConfirm] and [token] parameters are required and must not be null.
  UpdatePinConfirmModel({
    required this.pinToConfirm,
    required this.token,
  });

  /// The PIN to be confirmed during the update process.
  final String pinToConfirm;

  /// The token used for authentication or validation during the PIN confirmation process.
  final String token;
}

/// A model representing the completion of the PIN update process.
///
/// Contains the [user] information after the PIN update is successfully completed.
class UpdatePinCompleteModel extends UpdatePinModel {
  /// Creates an instance of [UpdatePinCompleteModel].
  ///
  /// The [user] parameter is required and must not be null.
  UpdatePinCompleteModel({required this.user});

  /// The user information after the PIN update is completed.
  final UserModel user;
}
