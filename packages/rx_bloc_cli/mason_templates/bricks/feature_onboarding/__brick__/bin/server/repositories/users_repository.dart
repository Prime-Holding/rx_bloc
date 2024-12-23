{{> licence.dart }}

import 'package:collection/collection.dart';

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

class UsersRepository {
  final List<UserModel> _registeredUsers = [];

  List<UserModel> getUsers() => _registeredUsers;

  UserModel? getUserById(String id) =>
      _registeredUsers.firstWhereOrNull((user) => user.id == id);

  UserModel? getUserByEmail(String email) =>
      _registeredUsers.firstWhereOrNull((user) => user.email == email);

  void createUser(UserModel user) => _registeredUsers.add(user);

  void updateUser(
    String userId, {
    String? phoneNumber,
    UserRole? role,
    ConfirmedCredentialsModel? confirmedCredentials,
  }) {
    final userIndex =
        _registeredUsers.indexWhere((element) => element.id == userId);
    final user = _registeredUsers[userIndex];
    _registeredUsers[userIndex] = user.copyWith(
      phoneNumber: phoneNumber,
      role: role ?? user.role,
      confirmedCredentials: confirmedCredentials ?? user.confirmedCredentials,
    );
  }

  void deleteUser(String id) =>
      _registeredUsers.removeWhere((user) => user.id == id);
}
