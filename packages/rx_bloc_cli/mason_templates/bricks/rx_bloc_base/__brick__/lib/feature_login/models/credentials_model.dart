{{> licence.dart }}

class CredentialsModel {
  CredentialsModel(this.username, this.password);

  final String username;
  final String password;

  bool equals(CredentialsModel credentials) =>
      username == credentials.username && password == credentials.password;
}
