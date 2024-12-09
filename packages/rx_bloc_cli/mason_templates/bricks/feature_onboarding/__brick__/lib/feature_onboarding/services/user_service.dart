import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/models/user_model.dart';
import '../repositories/user_repository.dart';

class UserService {
  UserService(
    this._errorMapper,
    this._userRepository,
  );

  final ErrorMapper _errorMapper;
  final UserRepository _userRepository;

  Future<UserModel> submitPhoneNumber(String phoneNumber) => _errorMapper
      .execute(() => _userRepository.submitPhoneNumber(phoneNumber));

  Future<UserModel> confirmPhoneNumber(String smsCode) =>
      _errorMapper.execute(() => _userRepository.confirmPhoneNumber(smsCode));
}
