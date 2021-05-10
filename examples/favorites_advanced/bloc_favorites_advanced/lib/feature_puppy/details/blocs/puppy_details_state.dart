part of 'puppy_details_bloc.dart';

@immutable
class PuppyDetailsState extends Equatable {
  PuppyDetailsState(
      {this.imagePath,
      this.name,
      this.breed,
      this.gender,
      this.characteristics,
      this.isFavourite,
      this.genderAndBreed,
      this.puppy});

  final String? imagePath;

  final String? name;

  final String? breed;

  final String? gender;

  final String? characteristics;

  final bool? isFavourite;

  final String? genderAndBreed;

  Puppy? puppy;

  @override
  List<Object?> get props => [
        imagePath,
        name,
        breed,
        gender,
        characteristics,
        isFavourite,
        genderAndBreed,
        puppy
      ];
  PuppyDetailsState copyWith({  required Puppy puppy})=>
      PuppyDetailsState(puppy: puppy);
}

// class PuppyDetailsInitial extends PuppyDetailsState {}
