import '../../base/models/user_model.dart';
import '../../base/repositories/users_repository.dart';

class EmailChangeService {
  const EmailChangeService(this._usersRepository);

  final UsersRepository _usersRepository;
  Future<UserModel> changeEmail(String email) =>
      _usersRepository.changeEmail(email);

  Future<UserModel> confirmEmail(String token) =>
      _usersRepository.confirmEmail(token);

  Future<UserModel> resendConfirmationEmail() =>
      _usersRepository.resendConfirmationEmail();
}
