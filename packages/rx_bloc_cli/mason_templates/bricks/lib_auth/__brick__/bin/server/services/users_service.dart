{{> licence.dart }}

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
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

  void createUser(UserModel user) => _usersRepository.createUser(user);

  bool isEmailInUse(String email) => _usersRepository.isEmailInUse(email);

  bool isPhoneInUse(String phoneNumber) =>
      _usersRepository.isPhoneInUse(phoneNumber);

  void addUnconfirmedPhoneNumber(String userId, String phoneNumber) =>
      _usersRepository.addUnconfirmedPhoneNumber(userId, phoneNumber);

  bool confirmPhoneNumber(String userId) =>
      _usersRepository.confirmPhoneNumber(userId);

  void updateUser(
    String userId, {
    String? email,
    String? phoneNumber,
    UserRole? role,
    ConfirmedCredentialsModel? confirmedCredentials,
    bool? hasPin,
  }) =>
      _usersRepository.updateUser(
        userId,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
        confirmedCredentials: confirmedCredentials,
        hasPin: hasPin,
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
}
