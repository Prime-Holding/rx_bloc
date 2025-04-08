{{> licence.dart }}

import 'package:collection/collection.dart';

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

const kPasswordResetTimeoutInSeconds = 60;

class UsersRepository {
  final List<UserModel> _registeredUsers = [];
  final Map<String, String> _passwords = {};
  final Map<String, String> _unconfirmedPhoneNumbers = {};{{#enable_forgotten_password}}
  final Map<String, int> _passwordResetLockedUsers = {};{{/enable_forgotten_password}}

  List<UserModel> getUsers() => _registeredUsers;

  UserModel? getUserById(String id) =>
      _registeredUsers.firstWhereOrNull((user) => user.id == id);

  UserModel? getUserByEmail(String email) =>
      _registeredUsers.firstWhereOrNull((user) => user.email == email);

  bool isUserRegistered(String email) => getUserByEmail(email) != null;

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
    final phoneNumber = _unconfirmedPhoneNumbers[userId];
    if (phoneNumber == null || user == null) return false;

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
    bool? hasPin,
  }) {
    final userIndex =
        _registeredUsers.indexWhere((element) => element.id == userId);
    final user = _registeredUsers[userIndex];
    _registeredUsers[userIndex] = user.copyWith(
      email: email ?? user.email,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      role: role ?? user.role,
      confirmedCredentials: confirmedCredentials ?? user.confirmedCredentials,
      hasPin: hasPin ?? user.hasPin,
    );
    return _registeredUsers[userIndex];
  }

  void deleteUser(String id, UserRole role) => _registeredUsers
      .removeWhere((user) => (user.id == id && user.role == role));

  void setPasswordForUser(String email, String password) =>
      _passwords[email] = password;

  String? getPasswordForUser(String email) => _passwords[email];{{#enable_forgotten_password}}

  bool isPasswordResetLockedForUser(String email) =>
      _passwordResetLockedUsers.keys.contains(email);

  int getPasswordResetTimeoutForUser(String email) =>
      _passwordResetLockedUsers[email] ?? kPasswordResetTimeoutInSeconds;

  void lockPasswordResetForUser(String email) =>
      _passwordResetLockedUsers[email] = kPasswordResetTimeoutInSeconds;

  void decrementPasswordResetTimeoutForUser(String email) =>
      _passwordResetLockedUsers.update(email, (timeout) => --timeout);

  void unlockPasswordResetForUser(String email) =>
      _passwordResetLockedUsers.remove(email);{{/enable_forgotten_password}}
}
