part of 'puppy_edit_bloc.dart';

class _UpdatePuppyData {
  _UpdatePuppyData({
    this.name,
    this.characteristics,
    this.imagePath,
    this.gender,
    this.breed,
    this.puppy,
  });

  final String name;
  final String characteristics;
  final String imagePath;
  final Gender gender;
  final BreedTypes breed;
  final Puppy puppy;
}
