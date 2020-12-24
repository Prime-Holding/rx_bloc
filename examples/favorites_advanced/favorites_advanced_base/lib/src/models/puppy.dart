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
  final String displayName;
  final BreedTypes breedType;
  final Gender gender;

  bool isFavorite;

  Puppy({
    @required this.id,
    @required this.name,
    @required this.asset,
    this.displayName,
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
          displayName == other.displayName &&
          isFavorite == other.isFavorite &&
          breedType == other.breedType;
    }

    return false;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() =>
      "{$id, $name, $displayName, ${breedCharacteristics == null ? "no displayBreedCharacteristics" : ""}, $asset, $displayName, $breedType, $isFavorite}";
}
