import 'package:favorites_advanced_base/src/utils/enums.dart';

class PuppyDataConversion {
  /// region Breed Type conversions
  static String getBreedTypeString(BreedTypes breedType) {
    String breedString = '';
    switch (breedType) {
      case BreedTypes.Retriever:
        breedString = 'Retriever';
        break;

      case BreedTypes.Mixed:
      default:
        breedString = 'Mixed';
    }
    return breedString;
  }

  static BreedTypes getBreedTypeFromString(String breedTypeString) {
    BreedTypes breedtype = BreedTypes.Mixed;
    switch (breedTypeString) {
      case 'Retriever':
        breedtype = BreedTypes.Retriever;
        break;

      case 'Mixed':
      default:
        breedtype = BreedTypes.Mixed;
    }
    return breedtype;
  }

  ///endregion

  /// region Gender conversions
  static String getGenderString(Gender gender) {
    String genderString = '';
    switch (gender) {
      case Gender.Male:
        genderString = 'Male';
        break;
      case Gender.Female:
      default:
        genderString = 'Female';
    }
    return genderString;
  }

  static Gender getGenderFromString(String genderString) {
    Gender gender = Gender.Female;

    switch (genderString) {
      case 'Male':
        gender = Gender.Male;
        break;
      case 'Female':
      default:
        gender = Gender.Female;
    }

    return gender;
  }

  /// endregion
}
