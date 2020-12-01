import 'package:flutter/cupertino.dart';

part '../extensions/puppy_extensions.dart';

class Puppy {
  final String id;
  final String name;
  final String breedCharacteristics;
  final String displayBreedCharacteristics;
  final String asset;
  final String displayName;
  bool isFavorite;

  Puppy({
    @required this.id,
    @required this.name,
    @required this.asset,
    this.displayName,
    this.isFavorite = false,
    this.breedCharacteristics =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    this.displayBreedCharacteristics,
  });

  @override
  bool operator ==(Object other) {
    if (other is Puppy) {
      return id == other.id &&
          name == other.name &&
          breedCharacteristics == other.breedCharacteristics &&
          displayBreedCharacteristics == other.displayBreedCharacteristics &&
          asset == other.asset &&
          displayName == other.displayName &&
          isFavorite == other.isFavorite;
    }

    return false;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() =>
      "{$id, $name, $displayName, $breedCharacteristics, $displayBreedCharacteristics, $asset, $displayName, $isFavorite}";
}
