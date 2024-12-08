import '../../base/data_sources/remote/user_remote_data_source.dart';
import '../../base/models/request_models/confirm_phone_number_request_model.dart';
import '../../base/models/request_models/phone_number_request_model.dart';
import '../../base/models/user_model.dart';

class UserRepository {
  UserRepository(this._userDataSource);

  final UserRemoteDataSource _userDataSource;

  Future<UserModel> submitPhoneNumber(String phoneNumber) => _userDataSource
      .submitPhoneNumber(PhoneNumberRequestModel(phoneNumber: phoneNumber));

  Future<UserModel> confirmPhoneNumber(String smsCode) => _userDataSource
      .confirmPhoneNumber(ConfirmPhoneNumberRequestModel(smsCode: smsCode));
}
