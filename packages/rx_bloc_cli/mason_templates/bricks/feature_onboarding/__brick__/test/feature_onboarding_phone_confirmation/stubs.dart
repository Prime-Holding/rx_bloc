{{> licence.dart }}

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/country_code_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

class Stubs {
  static const phone = '1234567890';
  static const countyCode = '381';
  static const countyName = 'Serbia';
  static const email = 'email@example.com';
  static const id = '1a2b3c';

  static final countryCodeModel = CountryCodeModel(
    code: countyCode,
    name: countyName,
  );

  static final confirmedCredentialsModel = ConfirmedCredentialsModel(
    email: true,
    phone: true,
  );

  static final UserModel user = UserModel(
    id: id,
    email: email,
    phoneNumber: phone,
    hasPin:false,
    role: UserRole.user,
    confirmedCredentials: confirmedCredentialsModel,
  );
}
