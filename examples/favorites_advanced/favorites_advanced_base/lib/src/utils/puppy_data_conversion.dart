import 'package:favorites_advanced_base/src/utils/enums.dart';

class PuppyDataConversion {
  static Map<BreedTypes, String> _dogBreeds = {
    BreedTypes.Mixed: 'Mixed',
    BreedTypes.GoldenRetriever: 'Golden Retriever',
    BreedTypes.LabradorRetriever: 'Labrador Retriever',
    BreedTypes.Labradoodle: 'Labradoodle',
    BreedTypes.Dachshund: 'Dachshund',
    BreedTypes.CarolinaDog: 'Carolina Dog',
    BreedTypes.Samoyed: 'Samoyed',
    BreedTypes.GermanShepherd: 'German Shepherd',
    BreedTypes.Havanese: 'Havanese',
    BreedTypes.Beagle: 'Beagle',
    BreedTypes.Rottweiler: 'Rottweiler',
    BreedTypes.CaneCorso: 'Cane Corso',
    BreedTypes.AustralianShepherd: 'Australian Shepherd',
    BreedTypes.BerneseMountainDog: 'Bernese Mountain Dog',
    BreedTypes.Cavachon: 'Cavachon',
    BreedTypes.Akita: 'Akita',
    BreedTypes.Husky: 'Husky',
    BreedTypes.StaffordshireTerrier: 'Staffordshire Terrier',
    BreedTypes.BichonFrise: 'Bichon Frise',
    BreedTypes.Bloodhound: 'Bloodhound',
    BreedTypes.BorderCollie: 'Border Collie',
    BreedTypes.Pug: 'Pug',
    BreedTypes.Chihuahua: 'Chihuahua',
    BreedTypes.DobermanPinscher: 'Doberman Pinscher',
  };

  /// region Breed Type conversions
  static String getBreedTypeString(BreedTypes breedType) =>
      _dogBreeds.entries
          .toList()
          .firstWhere((pair) => pair.key == breedType)
          ?.value ??
      _dogBreeds[BreedTypes.Mixed];

  static BreedTypes getBreedTypeFromString(String breedTypeString) =>
      _dogBreeds.entries
          .toList()
          .firstWhere((pair) => pair.value == breedTypeString)
          ?.key ??
      BreedTypes.Mixed;

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
