import 'package:favorites_advanced_base/src/utils/enums.dart';
import 'package:favorites_advanced_base/src/utils/puppy_data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

part '../extensions/puppy_extensions.dart';

class Puppy {
  final String id;
  final String name;
  final String breedCharacteristics;
  final String asset;
  final BreedTypes breedType;
  final Gender gender;

  bool isFavorite;

  // Properties that should simulate remote fetching of entity data
  final String displayName;
  final String displayCharacteristics;

  Puppy({
    @required this.id,
    @required this.name,
    @required this.asset,
    this.displayName,
    this.displayCharacteristics,
    this.isFavorite = false,
    this.breedCharacteristics =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    this.breedType = BreedTypes.Mixed,
    this.gender = Gender.Male,
  });

  @override
  bool operator ==(Object other) {
    if (other is Puppy) {
      return id == other.id &&
          name == other.name &&
          breedCharacteristics == other.breedCharacteristics &&
          asset == other.asset &&
          isFavorite == other.isFavorite &&
          breedType == other.breedType &&
          displayName == other.displayName &&
          displayCharacteristics == other.displayCharacteristics;
    }

    return false;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => '{$id, $name, $asset, $breedType, $isFavorite,'
      '${breedCharacteristics == null ? "no breedCharacteristics" : ""}'
      '${displayName == null ? "no displayName" : displayName}'
      '${displayCharacteristics == null ? "no displayBreedCharacteristics" : ""} }';
}
