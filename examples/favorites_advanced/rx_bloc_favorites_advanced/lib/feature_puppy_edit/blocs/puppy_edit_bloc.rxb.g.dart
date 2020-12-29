// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_edit_bloc.dart';

/// PuppyEditBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyEditBlocType extends RxBlocTypeBase {
  PuppyEditBlocEvents get events;

  PuppyEditBlocStates get states;
}

/// $PuppyEditBloc class - extended by the PuppyEditBloc bloc
/// {@nodoc}
abstract class $PuppyEditBloc extends RxBlocBase
    implements PuppyEditBlocEvents, PuppyEditBlocStates, PuppyEditBlocType {
  ///region Events

  ///region setEditingPuppy

  final _$setEditingPuppyEvent = PublishSubject<Puppy>();
  @override
  void setEditingPuppy(Puppy puppy) => _$setEditingPuppyEvent.add(puppy);

  ///endregion setEditingPuppy

  ///region updateName

  final _$updateNameEvent = PublishSubject<String>();
  @override
  void updateName(String newName) => _$updateNameEvent.add(newName);

  ///endregion updateName

  ///region updateBreed

  final _$updateBreedEvent = PublishSubject<BreedTypes>();
  @override
  void updateBreed(BreedTypes breedType) => _$updateBreedEvent.add(breedType);

  ///endregion updateBreed

  ///region updateGender

  final _$updateGenderEvent = PublishSubject<Gender>();
  @override
  void updateGender(Gender gender) => _$updateGenderEvent.add(gender);

  ///endregion updateGender

  ///region updateCharacteristics

  final _$updateCharacteristicsEvent = PublishSubject<String>();
  @override
  void updateCharacteristics(String newCharacteristics) =>
      _$updateCharacteristicsEvent.add(newCharacteristics);

  ///endregion updateCharacteristics

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

  ///region updatePuppyOld

  final _$updatePuppyOldEvent = PublishSubject<_UpdatePuppyOldEventArgs>();
  @override
  void updatePuppyOld(Puppy newPuppy, Puppy oldPuppy) =>
      _$updatePuppyOldEvent.add(_UpdatePuppyOldEventArgs(
        newPuppy: newPuppy,
        oldPuppy: oldPuppy,
      ));

  ///endregion updatePuppyOld

  ///endregion Events

  ///region States

  ///endregion States

  ///region Type

  @override
  PuppyEditBlocEvents get events => this;

  @override
  PuppyEditBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$setEditingPuppyEvent.close();
    _$updateNameEvent.close();
    _$updateBreedEvent.close();
    _$updateGenderEvent.close();
    _$updateCharacteristicsEvent.close();
    _$pickImageEvent.close();
    _$updatePuppyEvent.close();
    _$updatePuppyOldEvent.close();
    super.dispose();
  }
}

/// region Argument classes

/// region _UpdatePuppyOldEventArgs class

/// {@nodoc}
class _UpdatePuppyOldEventArgs {
  final Puppy newPuppy;
  final Puppy oldPuppy;

  const _UpdatePuppyOldEventArgs({
    this.newPuppy,
    this.oldPuppy,
  });
}

/// endregion _UpdatePuppyOldEventArgs class

/// endregion Argument classes
