{{> licence.dart }}

class ConfirmEmailModel {
  ConfirmEmailModel(this.token);

  /// The token used to confirm the user's email
  final String token;

  Map<String, Object?> toJson() => {
        'token': token,
      };
}
