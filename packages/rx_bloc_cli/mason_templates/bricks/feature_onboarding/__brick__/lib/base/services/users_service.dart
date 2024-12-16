import '../../base/models/user_model.dart';
import '../repositories/users_repository.dart';

class UsersService {
  UsersService(
    this._usersRepository,
  );

  final UsersRepository _usersRepository;

  /// Sets the phone number for the user
  Future<UserModel> submitPhoneNumber(String phoneNumber) =>
      _usersRepository.submitPhoneNumber(phoneNumber);

  /// Confirms a previously submitted phone number by providing the SMS code
  /// sent to the same number
  Future<UserModel> confirmPhoneNumber(String smsCode) =>
      _usersRepository.confirmPhoneNumber(smsCode);

  /// Resends the SMS code to the user's phone number
  Future<void> resendSmsCode() => _usersRepository.resendSmsCode();
}
