{{> licence.dart }}

{{#enable_forgotten_password}}import 'dart:async';

{{/enable_forgotten_password}}import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

import '..//utils/utilities.dart';
import '../repositories/users_repository.dart';

class UsersService {
  UsersService(this._usersRepository);

  final UsersRepository _usersRepository;

  List<UserModel> getUsers() => _usersRepository.getUsers();

  UserModel? getUserById(String id) => _usersRepository.getUserById(id);

  bool isTempUser(String id) => getUserById(id)?.role == UserRole.tempUser;

  UserModel? getUserByEmail(String email) =>
      _usersRepository.getUserByEmail(email);

  bool isUserRegistered(String email) =>
      _usersRepository.isUserRegistered(email);

  void createUser(UserModel user) => _usersRepository.createUser(user);

  bool isEmailInUse(String email) => _usersRepository.isEmailInUse(email);

  bool isPhoneInUse(String phoneNumber) =>
      _usersRepository.isPhoneInUse(phoneNumber);

  void addUnconfirmedPhoneNumber(String userId, String phoneNumber) =>
      _usersRepository.addUnconfirmedPhoneNumber(userId, phoneNumber);

  bool confirmPhoneNumber(String userId) =>
      _usersRepository.confirmPhoneNumber(userId);

  UserModel? updateUser(
    String userId, {
    String? email,
    String? phoneNumber,
    UserRole? role,
    ConfirmedCredentialsModel? confirmedCredentials,
    bool? hasPin,
    LastPinAction? lastPinAction,
  }) =>
      _usersRepository.updateUser(
        userId,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
        confirmedCredentials: confirmedCredentials,
        hasPin: hasPin,
        lastPinAction: lastPinAction,
      );

  void deleteUser(String id, UserRole role) => _usersRepository.deleteUser(id, role);

  UserModel registerOrFindUser(String email, String password) {
    final user = getUserByEmail(email);
    if (user != null) {
      return user;
    }
    final newUser = UserModel(
      id: generateRandomString(),
      hasPin: false,
      email: email,
      phoneNumber: null,
      role: UserRole.tempUser,
      confirmedCredentials:
          ConfirmedCredentialsModel(email: false, phone: false),
    );
    createUser(newUser);
    return newUser;
  }
   UserModel createRandomUser(String email, String password) {
    final newUser = UserModel(
      id: generateRandomString(),
      hasPin: false,
      email: email,
      phoneNumber: '0123456789',
      role: UserRole.user,
      confirmedCredentials: ConfirmedCredentialsModel(email: true, phone: true),
    );
    createUser(newUser);
    return newUser;
  }  
  void setPasswordForUser(String email, String password) =>
      _usersRepository.setPasswordForUser(email, password);

  String? getPasswordForUser(String email) =>
      _usersRepository.getPasswordForUser(email);{{#enable_forgotten_password}}

  bool isPasswordResetLockedForUser(String email) =>
      _usersRepository.isPasswordResetLockedForUser(email);

  int getPasswordResetTimeoutForUser(String email) =>
      _usersRepository.getPasswordResetTimeoutForUser(email);

  void lockPasswordResetForUser(String email) {
    _usersRepository.lockPasswordResetForUser(email);
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timer.tick == kPasswordResetTimeoutInSeconds) {
          _usersRepository.unlockPasswordResetForUser(email);
          return timer.cancel();
        }
        _usersRepository.decrementPasswordResetTimeoutForUser(email);
      },
    );
  }{{/enable_forgotten_password}}
}
