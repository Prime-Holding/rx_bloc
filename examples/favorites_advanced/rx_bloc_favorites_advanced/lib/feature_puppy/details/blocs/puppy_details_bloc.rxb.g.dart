// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class PuppyDetailsBlocType extends RxBlocTypeBase {
  PuppyDetailsEvents get events;
  PuppyDetailsStates get states;
}

/// [$PuppyDetailsBloc] extended by the [PuppyDetailsBloc]
/// {@nodoc}
abstract class $PuppyDetailsBloc extends RxBlocBase
    implements PuppyDetailsEvents, PuppyDetailsStates, PuppyDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// The state of [imagePath] implemented in [_mapToImagePathState]
  Stream<String>? _imagePathState;

  /// The state of [name] implemented in [_mapToNameState]
  Stream<String>? _nameState;

  /// The state of [breed] implemented in [_mapToBreedState]
  Stream<String?>? _breedState;

  /// The state of [gender] implemented in [_mapToGenderState]
  Stream<String>? _genderState;

  /// The state of [characteristics] implemented in [_mapToCharacteristicsState]
  Stream<String?>? _characteristicsState;

  /// The state of [isFavourite] implemented in [_mapToIsFavouriteState]
  Stream<bool>? _isFavouriteState;

  /// The state of [genderAndBreed] implemented in [_mapToGenderAndBreedState]
  Stream<String>? _genderAndBreedState;

  /// The state of [puppy] implemented in [_mapToPuppyState]
  Stream<Puppy>? _puppyState;

  @override
  Stream<String> get imagePath => _imagePathState ??= _mapToImagePathState();

  @override
  Stream<String> get name => _nameState ??= _mapToNameState();

  @override
  Stream<String?> get breed => _breedState ??= _mapToBreedState();

  @override
  Stream<String> get gender => _genderState ??= _mapToGenderState();

  @override
  Stream<String?> get characteristics =>
      _characteristicsState ??= _mapToCharacteristicsState();

  @override
  Stream<bool> get isFavourite =>
      _isFavouriteState ??= _mapToIsFavouriteState();

  @override
  Stream<String> get genderAndBreed =>
      _genderAndBreedState ??= _mapToGenderAndBreedState();

  @override
  Stream<Puppy> get puppy => _puppyState ??= _mapToPuppyState();

  Stream<String> _mapToImagePathState();

  Stream<String> _mapToNameState();

  Stream<String?> _mapToBreedState();

  Stream<String> _mapToGenderState();

  Stream<String?> _mapToCharacteristicsState();

  Stream<bool> _mapToIsFavouriteState();

  Stream<String> _mapToGenderAndBreedState();

  Stream<Puppy> _mapToPuppyState();

  @override
  PuppyDetailsEvents get events => this;

  @override
  PuppyDetailsStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
