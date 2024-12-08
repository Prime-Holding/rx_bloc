{{> licence.dart }}

import 'package:collection/collection.dart';

import 'package:{{project_name}}/base/models/user_model.dart';

class UsersRepository {
  final List<UserModel> _registeredUsers = [
    UserModel(
      id: '1',
      email: 'test_mail',
      phoneNumber: null,
      role: UserRole.tempUser,
      confirmedCredentials: ConfirmedCredentialsModel(
        email: true,
        phone: false,
      ),
    ),
  ];

  List<UserModel> getUsers() => _registeredUsers;

  UserModel? getUserById(String id) =>
      _registeredUsers.firstWhereOrNull((user) => user.id == id);

  UserModel? getUserByEmail(String email) =>
      _registeredUsers.firstWhereOrNull((user) => user.email == email);

  void createUser(UserModel user) => _registeredUsers.add(user);

  void updateUser(UserModel user) =>
      _registeredUsers.firstWhere((element) => element.id == user.id).copyWith(
            email: user.email,
            phoneNumber: user.phoneNumber,
            role: user.role,
            confirmedCredentials: user.confirmedCredentials,
          );

  void deleteUser(String id) =>
      _registeredUsers.removeWhere((user) => user.id == id);
}
