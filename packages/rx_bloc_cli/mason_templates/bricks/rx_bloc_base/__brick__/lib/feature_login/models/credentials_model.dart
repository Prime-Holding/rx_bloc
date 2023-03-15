{{> licence.dart }}

class CredentialsModel {
  CredentialsModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  bool equals(CredentialsModel credentials) =>
      email == credentials.email && password == credentials.password;
}
