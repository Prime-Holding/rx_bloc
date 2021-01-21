import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

part 'puppy_validator_extensions.dart';

typedef FieldValidator<T> = T Function(T);

class PuppyValidator {
  PuppyValidator({maxNameLength = 30, maxCharacteristicsLength = 250})
      : _maxNameLength = maxNameLength,
        _maxCharacteristicsLength = maxCharacteristicsLength;

  final int _maxNameLength;
  final int _maxCharacteristicsLength;

  String validatePuppyName(String name) {
    if (name == null || name.isEmpty) {
      throw RxFieldException(
        fieldValue: name,
        error: 'Name must not be empty.',
      );
    }

    final trimmedName = name.trim();

    if (trimmedName.length > _maxNameLength) {
      throw RxFieldException(
        fieldValue: name,
        error: 'Name too long.',
      );
    }

    return name;
  }

  String validatePuppyCharacteristics(String characteristics) {
    if (characteristics == null || characteristics.isEmpty) {
      throw RxFieldException(
        fieldValue: characteristics,
        error: 'Characteristics must not be empty.',
      );
    }

    final trimmedChars = characteristics.trim();

    if (trimmedChars.length > _maxCharacteristicsLength) {
      throw RxFieldException(
        fieldValue: characteristics,
        error: 'Characteristics must not exceed '
            '$_maxCharacteristicsLength characters.',
      );
    }

    return characteristics;
  }

  Gender validatePuppyGender(Gender gender) {
    if (gender == null || gender == Gender.None) {
      throw RxFieldException(
        fieldValue: gender,
        error: 'You have to select a gender.',
      );
    }

    return gender;
  }

  BreedType validatePuppyBreed(BreedType breed) {
    if (breed == null || breed == BreedType.None) {
      throw RxFieldException(
        fieldValue: breed,
        error: 'You have to select a gender.',
      );
    }

    return breed;
  }
}
