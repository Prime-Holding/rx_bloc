part of '../models/puppy.dart';

extension PuppUtils on Puppy {
  Puppy copyWith({
    String id,
    String name,
    String breedCharacteristics,
    Gender gender,
    BreedType breedType,
    bool isFavorite,
    String displayName,
    String displayCharacteristics,
    String asset,
  }) =>
      Puppy(
        id: id ?? this.id,
        name: name ?? this.name,
        breedCharacteristics: breedCharacteristics ?? this.breedCharacteristics,
        asset: asset ?? this.asset,
        isFavorite: isFavorite ?? this.isFavorite,
        gender: gender ?? this.gender,
        breedType: breedType ?? this.breedType,
        displayName: displayName ?? this.displayName ,
        displayCharacteristics:
        displayCharacteristics ?? this.displayCharacteristics,
      );

  Puppy copyWithPuppy(Puppy puppy) => Puppy(
        id: puppy.id ?? id,
        name: puppy.name ?? name,
        breedCharacteristics:
            puppy.breedCharacteristics ?? breedCharacteristics,
        asset: puppy.asset ?? asset,
        isFavorite: puppy.isFavorite ?? isFavorite,
        gender: puppy.gender ?? gender,
        breedType: puppy.breedType ?? breedType,
        displayName: puppy.displayName ?? displayName,
        displayCharacteristics:
            puppy.displayCharacteristics ?? displayCharacteristics,
      );

  /// Check whether the current entity has all needed extra details.
  bool hasExtraDetails() => breedCharacteristics != null && displayName != null;

  String get genderAsString => PuppyDataConversion.getGenderString(gender);

  String get breedTypeAsString =>
      PuppyDataConversion.getBreedTypeString(breedType);
}

extension ListPuppyUtils on List<Puppy> {
  /// Get a list of [Puppy.id]
  List<String> get ids => map((puppy) => puppy.id).toList();

  /// Get list of puppies, which have no extra details
  List<Puppy> whereNoExtraDetails() =>
      where((puppy) => !puppy.hasExtraDetails()).toList();

  /// Merge the current list with the given list of [puppies].
  ///
  /// 1. In case that any of the provided [puppies] it not part of the current
  /// list, the returned result will include the entities from the provided [puppies]
  /// 2. In case that any of the provided [puppies] it's not part of the
  /// current list it will be added at the end of the list.
  List<Puppy> mergeWith(List<Puppy> puppies) {
    var copiedList = [...this];

    puppies.forEach(
      (puppy) => copiedList = copiedList._mergeWithPuppy(puppy),
    );

    return copiedList;
  }

  /// Get a list with added or removed entity based on the [Puppy.isFavorite] flag
  List<Puppy> manageFavoriteList(List<Puppy> puppies) {
    var copiedList = [...this];

    puppies.forEach(
      (puppy) => copiedList = copiedList._manageFavoritePuppy(puppy),
    );

    return copiedList;
  }

  List<Puppy> _mergeWithPuppy(Puppy puppy) {
    final index = indexWhere((element) => element.id == puppy.id);

    if (index >= 0 && index < length) {
      replaceRange(index, index + 1, [puppy]);
      return this;
    }

    add(puppy);

    return this;
  }

  //TODO cover the updating of the puppy with a unit test
  List<Puppy> _manageFavoritePuppy(Puppy puppy) {
    //handle removing puppies which aren't favourite
    if (!puppy.isFavorite) {
      removeWhere((element) => element.id == puppy.id);
      return this;
    }

    final index = indexWhere((element) => element.id == puppy.id);

    //handle adding new favourite puppy
    if (index == -1) {
      add(puppy);
      return this;
    }

    //handle updating already existing favourite puppy
    this[index] = this[index].copyWithPuppy(puppy);

    return this;
  }
}
