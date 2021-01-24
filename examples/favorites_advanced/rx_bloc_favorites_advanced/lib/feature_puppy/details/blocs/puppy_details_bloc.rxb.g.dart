// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_details_bloc.dart';

/// PuppyDetailsBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyDetailsBlocType extends RxBlocTypeBase {
  PuppyDetailsEvents get events;

  PuppyDetailsStates get states;
}

/// $PuppyDetailsBloc class - extended by the PuppyDetailsBloc bloc
/// {@nodoc}
abstract class $PuppyDetailsBloc extends RxBlocBase
    implements PuppyDetailsEvents, PuppyDetailsStates, PuppyDetailsBlocType {
  ///region Events

  ///endregion Events

  ///region States

  ///region imagePath
  Stream<String> _imagePathState;

  @override
  Stream<String> get imagePath => _imagePathState ??= _mapToImagePathState();

  Stream<String> _mapToImagePathState();

  ///endregion imagePath

  ///region name
  Stream<String> _nameState;

  @override
  Stream<String> get name => _nameState ??= _mapToNameState();

  Stream<String> _mapToNameState();

  ///endregion name

  ///region breed
  Stream<String> _breedState;

  @override
  Stream<String> get breed => _breedState ??= _mapToBreedState();

  Stream<String> _mapToBreedState();

  ///endregion breed

  ///region gender
  Stream<String> _genderState;

  @override
  Stream<String> get gender => _genderState ??= _mapToGenderState();

  Stream<String> _mapToGenderState();

  ///endregion gender

  ///region characteristics
  Stream<String> _characteristicsState;

  @override
  Stream<String> get characteristics =>
      _characteristicsState ??= _mapToCharacteristicsState();

  Stream<String> _mapToCharacteristicsState();

  ///endregion characteristics

  ///region isFavourite
  Stream<bool> _isFavouriteState;

  @override
  Stream<bool> get isFavourite =>
      _isFavouriteState ??= _mapToIsFavouriteState();

  Stream<bool> _mapToIsFavouriteState();

  ///endregion isFavourite

  ///region genderAndCharacteristics
  Stream<String> _genderAndCharacteristicsState;

  @override
  Stream<String> get genderAndCharacteristics =>
      _genderAndCharacteristicsState ??= _mapToGenderAndCharacteristicsState();

  Stream<String> _mapToGenderAndCharacteristicsState();

  ///endregion genderAndCharacteristics

  ///region puppy
  Stream<Puppy> _puppyState;

  @override
  Stream<Puppy> get puppy => _puppyState ??= _mapToPuppyState();

  Stream<Puppy> _mapToPuppyState();

  ///endregion puppy

  ///endregion States

  ///region Type

  @override
  PuppyDetailsEvents get events => this;

  @override
  PuppyDetailsStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    super.dispose();
  }
}
