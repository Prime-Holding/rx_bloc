import 'package:favorites_advanced_base/core.dart';

class PuppyFormValidator {
  static const int _maxNameLength = 30;
  static const int _maxCharacteristicsLength = 250;
  static const _nameMustNotBeEmpty = 'Name must not be empty.';
  static const _nameTooLong = 'Name too long.';
  static const _selectABreed = 'You have to select a breed.';
  static const _selectAGender = 'You have to select a gender.';
  static const _charMustNotBeEmpty = 'Characteristics must not be empty';
  static const _charLengthLimitation = 'Characteristics must not exceed '
      '$_maxCharacteristicsLength characters.';

  static String? nameValidation(String? username) {
    if (username != null) {
      if (username.isEmpty) {
        return _nameMustNotBeEmpty;
      }

      final trimmedName = username.trim();

      if (trimmedName.length > _maxNameLength) {
        return _nameTooLong;
      }
    }
    return null;
  }

  static String? breedValidation(BreedType? breedType) {
    // print('breed validation $breedType');
    if (breedType == BreedType.None || breedType == null) {
      return _selectABreed;
    }
    return null;
  }

  static String? genderValidation(Gender? gender) {
    if (gender == Gender.None || gender == null) {
      return _selectAGender;
    }
    return null;
  }

  static String? characteristicsValidation(String? characteristics) {
    if (characteristics != null) {
      if (characteristics.isEmpty) {
        return _charMustNotBeEmpty;
      }

      final trimmedChars = characteristics.trim();

      if (trimmedChars.length > _maxCharacteristicsLength) {
        return _charLengthLimitation;
      }
    }
    return null;
  }
}
