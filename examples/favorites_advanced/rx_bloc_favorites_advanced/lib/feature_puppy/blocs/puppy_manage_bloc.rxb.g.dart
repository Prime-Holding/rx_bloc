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

  ///region updateName

  final _$updateNameEvent = BehaviorSubject.seeded('');
  @override
  void updateName(String newName) => _$updateNameEvent.add(newName);

  ///endregion updateName

  ///region updateCharacteristics

  final _$updateCharacteristicsEvent = BehaviorSubject.seeded('');
  @override
  void updateCharacteristics(String newCharacteristics) =>
      _$updateCharacteristicsEvent.add(newCharacteristics);

  ///endregion updateCharacteristics

  ///region updateGender

  final _$updateGenderEvent = BehaviorSubject.seeded(Gender.None);
  @override
  void updateGender(Gender gender) => _$updateGenderEvent.add(gender);

  ///endregion updateGender

  ///region updateBreed

  final _$updateBreedEvent = BehaviorSubject.seeded(BreedType.None);
  @override
  void updateBreed(BreedType breedType) => _$updateBreedEvent.add(breedType);

  ///endregion updateBreed

  ///region pickImage

  final _$pickImageEvent = PublishSubject<ImagePickerActions>();
  @override
  void pickImage(ImagePickerActions source) => _$pickImageEvent.add(source);

  ///endregion pickImage

  ///region updatePuppy

  final _$updatePuppyEvent = PublishSubject<void>();
  @override
  void updatePuppy() => _$updatePuppyEvent.add(null);

  ///endregion updatePuppy

  ///endregion Events

  ///region States

  ///region isSaveEnabled
  Stream<bool> _isSaveEnabledState;

  @override
  Stream<bool> get isSaveEnabled =>
      _isSaveEnabledState ??= _mapToIsSaveEnabledState();

  Stream<bool> _mapToIsSaveEnabledState();

  ///endregion isSaveEnabled

  ///region imagePath
  Stream<String> _imagePathState;

  @override
  Stream<String> get imagePath => _imagePathState ??= _mapToImagePathState();

  Stream<String> _mapToImagePathState();

  ///endregion imagePath

  ///region gender
  Stream<Gender> _genderState;

  @override
  Stream<Gender> get gender => _genderState ??= _mapToGenderState();

  Stream<Gender> _mapToGenderState();

  ///endregion gender

  ///region breed
  Stream<BreedType> _breedState;

  @override
  Stream<BreedType> get breed => _breedState ??= _mapToBreedState();

  Stream<BreedType> _mapToBreedState();

  ///endregion breed

  ///region name
  Stream<String> _nameState;

  @override
  Stream<String> get name => _nameState ??= _mapToNameState();

  Stream<String> _mapToNameState();

  ///endregion name

  ///region characteristics
  Stream<String> _characteristicsState;

  @override
  Stream<String> get characteristics =>
      _characteristicsState ??= _mapToCharacteristicsState();

  Stream<String> _mapToCharacteristicsState();

  ///endregion characteristics

  ///region updateStatus
  Stream<Result<void>> _updateStatusState;

  @override
  Stream<Result<void>> get updateStatus =>
      _updateStatusState ??= _mapToUpdateStatusState();

  Stream<Result<void>> _mapToUpdateStatusState();

  ///endregion updateStatus

  ///region processingUpdate
  Stream<bool> _processingUpdateState;

  @override
  Stream<bool> get processingUpdate =>
      _processingUpdateState ??= _mapToProcessingUpdateState();

  Stream<bool> _mapToProcessingUpdateState();

  ///endregion processingUpdate

  ///region successfulUpdate
  Stream<bool> _successfulUpdateState;

  @override
  Stream<bool> get successfulUpdate =>
      _successfulUpdateState ??= _mapToSuccessfulUpdateState();

  Stream<bool> _mapToSuccessfulUpdateState();

  ///endregion successfulUpdate

  ///region updateError
  Stream<String> _updateErrorState;

  @override
  Stream<String> get updateError =>
      _updateErrorState ??= _mapToUpdateErrorState();

  Stream<String> _mapToUpdateErrorState();

  ///endregion updateError

  ///region showErrors
  Stream<bool> _showErrorsState;

  @override
  Stream<bool> get showErrors => _showErrorsState ??= _mapToShowErrorsState();

  Stream<bool> _mapToShowErrorsState();

  ///endregion showErrors

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
    _$updateNameEvent.close();
    _$updateCharacteristicsEvent.close();
    _$updateGenderEvent.close();
    _$updateBreedEvent.close();
    _$pickImageEvent.close();
    _$updatePuppyEvent.close();
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
