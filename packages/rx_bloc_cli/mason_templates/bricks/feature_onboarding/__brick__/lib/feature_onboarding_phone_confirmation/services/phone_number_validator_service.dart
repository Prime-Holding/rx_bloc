import '../../app_extensions.dart';
import '../../base/models/country_code_model.dart';
import '../../base/models/errors/error_model.dart';

/// Service performing validation of phone number and country code
class PhoneNumberValidatorService {
  const PhoneNumberValidatorService();

  String validateNumberAndCountryCode(
    String phoneNumber,
    CountryCodeModel? countryCode,
  ) {
    if (countryCode == null || countryCode.code.isEmpty) {
      throw FieldRequiredErrorModel(
        errorValue: S.current.countryCode,
        fieldValue: countryCode?.code ?? '',
      );
    }

    if (phoneNumber.isEmpty) {
      throw FieldRequiredErrorModel(
        errorValue: S.current.phoneNumber,
        fieldValue: phoneNumber,
      );
    } else if (phoneNumber.length < 8) {
      throw FieldErrorModel(
        errorValue: S.current.tooShort,
        fieldValue: phoneNumber,
      );
    } else if (phoneNumber.length > 13) {
      throw FieldErrorModel(
        errorValue: S.current.tooLong,
        fieldValue: phoneNumber,
      );
    }

    return phoneNumber;
  }
}
