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
  late final Stream<String> _imagePathState = _mapToImagePathState();

  /// The state of [name] implemented in [_mapToNameState]
  late final Stream<String> _nameState = _mapToNameState();

  /// The state of [breed] implemented in [_mapToBreedState]
  late final Stream<String?> _breedState = _mapToBreedState();

  /// The state of [gender] implemented in [_mapToGenderState]
  late final Stream<String> _genderState = _mapToGenderState();

  /// The state of [characteristics] implemented in [_mapToCharacteristicsState]
  late final Stream<String?> _characteristicsState =
      _mapToCharacteristicsState();

  /// The state of [isFavourite] implemented in [_mapToIsFavouriteState]
  late final Stream<bool> _isFavouriteState = _mapToIsFavouriteState();

  /// The state of [genderAndBreed] implemented in [_mapToGenderAndBreedState]
  late final Stream<String> _genderAndBreedState = _mapToGenderAndBreedState();

  /// The state of [puppy] implemented in [_mapToPuppyState]
  late final Stream<Puppy> _puppyState = _mapToPuppyState();

  @override
  Stream<String> get imagePath => _imagePathState;

  @override
  Stream<String> get name => _nameState;

  @override
  Stream<String?> get breed => _breedState;

  @override
  Stream<String> get gender => _genderState;

  @override
  Stream<String?> get characteristics => _characteristicsState;

  @override
  Stream<bool> get isFavourite => _isFavouriteState;

  @override
  Stream<String> get genderAndBreed => _genderAndBreedState;

  @override
  Stream<Puppy> get puppy => _puppyState;

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
