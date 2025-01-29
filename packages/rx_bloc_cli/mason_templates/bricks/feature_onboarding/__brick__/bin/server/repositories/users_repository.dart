{{> licence.dart }}

import 'package:collection/collection.dart';

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

class UsersRepository {
  final List<UserModel> _registeredUsers = [];
final Map<String, String> _unconfirmedPhoneNumbers = {};

  List<UserModel> getUsers() => _registeredUsers;

  UserModel? getUserById(String id) =>
      _registeredUsers.firstWhereOrNull((user) => user.id == id);

  UserModel? getUserByEmail(String email) =>
      _registeredUsers.firstWhereOrNull((user) => user.email == email);

  void createUser(UserModel user) => _registeredUsers.add(user);

  bool isEmailInUse(String email) =>
      _registeredUsers.any((user) => user.email == email);

  bool isPhoneInUse(String phoneNumber) =>
      _registeredUsers.any((user) => user.phoneNumber == phoneNumber);

  void addUnconfirmedPhoneNumber(String userId, String phoneNumber) {
    _unconfirmedPhoneNumbers[userId] = phoneNumber;
  }

  bool confirmPhoneNumber(String userId) {
    final user = getUserById(userId);
    if (!_unconfirmedPhoneNumbers.containsKey(userId) || user == null) {
      return false;
    }

    final phoneNumber = _unconfirmedPhoneNumbers[userId]!;
    updateUser(
      userId,
      phoneNumber: phoneNumber,
      confirmedCredentials: user.confirmedCredentials.copyWith(phone: true),
    );
    _unconfirmedPhoneNumbers.remove(userId);

    return true;
  }

  UserModel? updateUser(
    String userId, {
    String? email,
    String? phoneNumber,
    UserRole? role,
    ConfirmedCredentialsModel? confirmedCredentials,
  }) {
    final userIndex =
        _registeredUsers.indexWhere((element) => element.id == userId);
    final user = _registeredUsers[userIndex];
    _registeredUsers[userIndex] = user.copyWith(
      email: email ?? user.email,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      role: role ?? user.role,
      confirmedCredentials: confirmedCredentials ?? user.confirmedCredentials,
    );
    return _registeredUsers[userIndex];
  }

  void deleteUser(String id, UserRole role) => _registeredUsers
      .removeWhere((user) => (user.id == id && user.role == role));
}
