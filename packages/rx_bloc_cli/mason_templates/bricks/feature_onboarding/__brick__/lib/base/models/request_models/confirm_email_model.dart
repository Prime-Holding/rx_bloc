{{> licence.dart }}

class ConfirmEmailModel {
  ConfirmEmailModel(this.token);

  final String token;

  Map<String, Object?> toJson() => {
        'token': token,
      };
}
