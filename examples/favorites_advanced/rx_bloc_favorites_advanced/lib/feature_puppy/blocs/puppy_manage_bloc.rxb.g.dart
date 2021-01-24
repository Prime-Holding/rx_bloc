// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_manage_bloc.dart';

/// PuppyManageBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyManageBlocType extends RxBlocTypeBase {
  PuppyManageEvents get events;

  PuppyManageStates get states;
}

/// $PuppyManageBloc class - extended by the PuppyManageBloc bloc
/// {@nodoc}
abstract class $PuppyManageBloc extends RxBlocBase
    implements PuppyManageEvents, PuppyManageStates, PuppyManageBlocType {
  ///region Events

  ///region markAsFavorite

  final _$markAsFavoriteEvent = PublishSubject<_MarkAsFavoriteEventArgs>();
  @override
  void markAsFavorite({Puppy puppy, bool isFavorite}) =>
      _$markAsFavoriteEvent.add(_MarkAsFavoriteEventArgs(
        puppy: puppy,
        isFavorite: isFavorite,
      ));

  ///endregion markAsFavorite

  ///region setName

  final _$setNameEvent = BehaviorSubject.seeded('');
  @override
  void setName(String newName) => _$setNameEvent.add(newName);

  ///endregion setName

  ///region setCharacteristics

  final _$setCharacteristicsEvent = BehaviorSubject.seeded('');
  @override
  void setCharacteristics(String newCharacteristics) =>
      _$setCharacteristicsEvent.add(newCharacteristics);

  ///endregion setCharacteristics

  ///region setGender

  final _$setGenderEvent = PublishSubject<Gender>();
  @override
  void setGender(Gender gender) => _$setGenderEvent.add(gender);

  ///endregion setGender

  ///region setBreed

  final _$setBreedEvent = PublishSubject<BreedType>();
  @override
  void setBreed(BreedType breedType) => _$setBreedEvent.add(breedType);

  ///endregion setBreed

  ///region setImage

  final _$setImageEvent = PublishSubject<ImagePickerActions>();
  @override
  void setImage(ImagePickerActions source) => _$setImageEvent.add(source);

  ///endregion setImage

  ///region savePuppy

  final _$savePuppyEvent = PublishSubject<void>();
  @override
  void savePuppy() => _$savePuppyEvent.add(null);

  ///endregion savePuppy

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
  Stream<BreedType> _breedState;

  @override
  Stream<BreedType> get breed => _breedState ??= _mapToBreedState();

  Stream<BreedType> _mapToBreedState();

  ///endregion breed

  ///region gender
  Stream<Gender> _genderState;

  @override
  Stream<Gender> get gender => _genderState ??= _mapToGenderState();

  Stream<Gender> _mapToGenderState();

  ///endregion gender

  ///region characteristics
  Stream<String> _characteristicsState;

  @override
  Stream<String> get characteristics =>
      _characteristicsState ??= _mapToCharacteristicsState();

  Stream<String> _mapToCharacteristicsState();

  ///endregion characteristics

  ///region showErrors
  Stream<bool> _showErrorsState;

  @override
  Stream<bool> get showErrors => _showErrorsState ??= _mapToShowErrorsState();

  Stream<bool> _mapToShowErrorsState();

  ///endregion showErrors

  ///region isSaveEnabled
  Stream<bool> _isSaveEnabledState;

  @override
  Stream<bool> get isSaveEnabled =>
      _isSaveEnabledState ??= _mapToIsSaveEnabledState();

  Stream<bool> _mapToIsSaveEnabledState();

  ///endregion isSaveEnabled

  ///region updateComplete
  Stream<bool> _updateCompleteState;

  @override
  Stream<bool> get updateComplete =>
      _updateCompleteState ??= _mapToUpdateCompleteState();

  Stream<bool> _mapToUpdateCompleteState();

  ///endregion updateComplete

  ///endregion States

  ///region Type

  @override
  PuppyManageEvents get events => this;

  @override
  PuppyManageStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$markAsFavoriteEvent.close();
    _$setNameEvent.close();
    _$setCharacteristicsEvent.close();
    _$setGenderEvent.close();
    _$setBreedEvent.close();
    _$setImageEvent.close();
    _$savePuppyEvent.close();
    super.dispose();
  }
}

/// region Argument classes

/// region _MarkAsFavoriteEventArgs class

/// {@nodoc}
class _MarkAsFavoriteEventArgs {
  final Puppy puppy;
  final bool isFavorite;

  const _MarkAsFavoriteEventArgs({
    this.puppy,
    this.isFavorite,
  });
}

/// endregion _MarkAsFavoriteEventArgs class

/// endregion Argument classes
