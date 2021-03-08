import 'package:collection/collection.dart' show IterableExtension;
import 'package:favorites_advanced_base/src/utils/enums.dart';

class PuppyDataConversion {
  static Map<BreedType, String> _dogBreeds = {
    BreedType.None: 'None',
    BreedType.Mixed: 'Mixed',
    BreedType.GoldenRetriever: 'Golden Retriever',
    BreedType.LabradorRetriever: 'Labrador Retriever',
    BreedType.Labradoodle: 'Labradoodle',
    BreedType.Dachshund: 'Dachshund',
    BreedType.CarolinaDog: 'Carolina Dog',
    BreedType.Samoyed: 'Samoyed',
    BreedType.GermanShepherd: 'German Shepherd',
    BreedType.Havanese: 'Havanese',
    BreedType.Beagle: 'Beagle',
    BreedType.Rottweiler: 'Rottweiler',
    BreedType.CaneCorso: 'Cane Corso',
    BreedType.AustralianShepherd: 'Australian Shepherd',
    BreedType.BerneseMountainDog: 'Bernese Mountain Dog',
    BreedType.Cavachon: 'Cavachon',
    BreedType.Akita: 'Akita',
    BreedType.Husky: 'Husky',
    BreedType.StaffordshireTerrier: 'Staffordshire Terrier',
    BreedType.BichonFrise: 'Bichon Frise',
    BreedType.Bloodhound: 'Bloodhound',
    BreedType.BorderCollie: 'Border Collie',
    BreedType.Pug: 'Pug',
    BreedType.Chihuahua: 'Chihuahua',
    BreedType.DobermanPinscher: 'Doberman Pinscher',
  };

  /// region Breed Type conversions
  static String? getBreedTypeString(BreedType breedType) =>
      _dogBreeds.entries
          .toList()
          .firstWhereOrNull((pair) => pair.key == breedType)
          ?.value ??
      _dogBreeds[BreedType.None];

  static BreedType getBreedTypeFromString(String breedTypeString) =>
      _dogBreeds.entries
          .toList()
          .firstWhere(
            (pair) => pair.value == breedTypeString,
            orElse: () => MapEntry(BreedType.None, 'None'),
          )
          .key;

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
