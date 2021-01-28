part of 'puppy_details_bloc.dart';

extension _OnPuppyUpdated on CoordinatorBlocType {
  Stream<Puppy> onPuppyUpdated(Puppy puppy) =>
      states.onPuppiesUpdated.wherePuppy(puppy);
}

extension _WherePuppyUpdated on Stream<List<Puppy>> {
  Stream<Puppy> wherePuppy(Puppy puppy) => map<Puppy>(
        (puppies) => puppies.firstWhere(
          (item) => item.id == puppy.id,
          orElse: () => null,
        ),
      ).where((puppy) => puppy != null);
}

extension _ExtractPuppyProperties on Stream<Puppy> {
  Stream<String> mapToBreed() => map((puppy) => puppy.breedTypeAsString);

  Stream<String> mapToCharacteristics() =>
      map((puppy) => puppy.displayCharacteristics);

  Stream<String> mapToGender() => map((puppy) => puppy.genderAsString);

  Stream<String> mapToImagePath() => map((puppy) => puppy.asset);

  Stream<String> name() => map((puppy) => puppy.name);

  Stream<bool> mapToIsFavourite() => map((puppy) => puppy.isFavorite);

  Stream<String> mapToGenderAndBreed() =>
      map((puppy) => '${puppy.genderAsString}, ${puppy.breedTypeAsString}');
}
