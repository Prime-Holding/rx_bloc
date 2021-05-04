part of 'puppy_details_bloc.dart';

@immutable
class PuppyDetailsState {
  const PuppyDetailsState({this.imagePath, this.name, this.breed, this.gender,
      this.characteristics, this.isFavourite, this.genderAndBreed, this.puppy});

  final String? imagePath;

  final String? name;

  final String? breed;

  final String? gender;

  final String? characteristics;

  final bool? isFavourite;

  final String? genderAndBreed;

  final Puppy? puppy;
}

// class PuppyDetailsInitial extends PuppyDetailsState {}
