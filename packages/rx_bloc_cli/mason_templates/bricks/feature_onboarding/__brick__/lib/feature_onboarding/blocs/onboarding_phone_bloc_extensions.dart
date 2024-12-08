part of 'onboarding_phone_bloc.dart';

extension OnboardingBlocExtensions on OnboardingPhoneBloc {
  /// Validates the phone number
  bool _validatePhoneNumber(String? countryCode, String phoneNumber) {
    if (countryCode == null || countryCode.isEmpty) {
      throw InvalidCountryCodeError();
    } else if (phoneNumber.isEmpty) {
      throw InvalidPhoneNumberError();
    } else if (phoneNumber.length < 8) {
      throw PhoneNumberTooShortError();
    }

    return true;
  }
}
