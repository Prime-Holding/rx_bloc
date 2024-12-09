{{> licence.dart }}

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

import '../repositories/users_repository.dart';
import '../utils/utilities.dart';

class UsersService {
  UsersService(this._usersRepository);

  final UsersRepository _usersRepository;

  List<UserModel> getUsers() => _usersRepository.getUsers();

  UserModel? getUserById(String id) => _usersRepository.getUserById(id);

  UserModel? getUserByEmail(String email) =>
      _usersRepository.getUserByEmail(email);

  void createUser(UserModel user) => _usersRepository.createUser(user);

  void updateUser(UserModel user) => _usersRepository.updateUser(user);

  void deleteUser(String id) => _usersRepository.deleteUser(id);

  UserModel registerOrFindUser(String email, String password) {
    final user = getUserByEmail(email);
    if (user != null) {
      return user;
    }
    final newUser = UserModel(
      id: generateRandomString(),
      email: email,
      phoneNumber: null,
      role: UserRole.tempUser,
      confirmedCredentials:
          ConfirmedCredentialsModel(email: false, phone: false),
    );
    createUser(newUser);
    return newUser;
  }
}
