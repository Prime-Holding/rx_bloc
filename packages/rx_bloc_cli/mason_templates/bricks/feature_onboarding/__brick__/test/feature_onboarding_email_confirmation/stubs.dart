{{> licence.dart }}

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

class Stubs {
  static const email = 'email@example.com';
  static const phone = '1234567890';
  static const id = '1a2b3c';

  static final confirmedCredentialsModel = ConfirmedCredentialsModel(
    email: true,
    phone: true,
  );

  static final user = UserModel(
    id: id,
    email: email,
    hasPin:false,
    phoneNumber: phone,
    role: UserRole.user,
    confirmedCredentials: confirmedCredentialsModel,
  );
}
