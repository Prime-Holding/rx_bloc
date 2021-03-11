// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_manage_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class PuppyManageBlocType extends RxBlocTypeBase {
  PuppyManageEvents get events;
  PuppyManageStates get states;
}

/// [$PuppyManageBloc] extended by the [PuppyManageBloc]
/// {@nodoc}
abstract class $PuppyManageBloc extends RxBlocBase
    implements PuppyManageEvents, PuppyManageStates, PuppyManageBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [markAsFavorite]
  final _$markAsFavoriteEvent = PublishSubject<_MarkAsFavoriteEventArgs>();

  /// Тhe [Subject] where events sink to by calling [setName]
  final _$setNameEvent = PublishSubject<String>();

  /// Тhe [Subject] where events sink to by calling [setCharacteristics]
  final _$setCharacteristicsEvent = PublishSubject<String>();

  /// Тhe [Subject] where events sink to by calling [setGender]
  final _$setGenderEvent = PublishSubject<Gender>();

  /// Тhe [Subject] where events sink to by calling [setBreed]
  final _$setBreedEvent = PublishSubject<BreedType>();

  /// Тhe [Subject] where events sink to by calling [setImage]
  final _$setImageEvent = PublishSubject<ImagePickerAction>();

  /// Тhe [Subject] where events sink to by calling [savePuppy]
  final _$savePuppyEvent = PublishSubject<void>();

  /// The state of [imagePath] implemented in [_mapToImagePathState]
  Stream<String>? _imagePathState;

  /// The state of [name] implemented in [_mapToNameState]
  Stream<String>? _nameState;

  /// The state of [breed] implemented in [_mapToBreedState]
  Stream<BreedType>? _breedState;

  /// The state of [gender] implemented in [_mapToGenderState]
  Stream<Gender>? _genderState;

  /// The state of [characteristics] implemented in [_mapToCharacteristicsState]
  Stream<String>? _characteristicsState;

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  Stream<bool>? _showErrorsState;

  /// The state of [isSaveEnabled] implemented in [_mapToIsSaveEnabledState]
  Stream<bool>? _isSaveEnabledState;

  /// The state of [updateComplete] implemented in [_mapToUpdateCompleteState]
  Stream<bool>? _updateCompleteState;

  @override
  void markAsFavorite({required Puppy puppy, required bool isFavorite}) =>
      _$markAsFavoriteEvent
          .add(_MarkAsFavoriteEventArgs(puppy: puppy, isFavorite: isFavorite));

  @override
  void setName(String newName) => _$setNameEvent.add(newName);

  @override
  void setCharacteristics(String newCharacteristics) =>
      _$setCharacteristicsEvent.add(newCharacteristics);

  @override
  void setGender(Gender gender) => _$setGenderEvent.add(gender);

  @override
  void setBreed(BreedType breedType) => _$setBreedEvent.add(breedType);

  @override
  void setImage(ImagePickerAction source) => _$setImageEvent.add(source);

  @override
  void savePuppy() => _$savePuppyEvent.add(null);

  @override
  Stream<String> get imagePath => _imagePathState ??= _mapToImagePathState();

  @override
  Stream<String> get name => _nameState ??= _mapToNameState();

  @override
  Stream<BreedType> get breed => _breedState ??= _mapToBreedState();

  @override
  Stream<Gender> get gender => _genderState ??= _mapToGenderState();

  @override
  Stream<String> get characteristics =>
      _characteristicsState ??= _mapToCharacteristicsState();

  @override
  Stream<bool> get showErrors => _showErrorsState ??= _mapToShowErrorsState();

  @override
  Stream<bool> get isSaveEnabled =>
      _isSaveEnabledState ??= _mapToIsSaveEnabledState();

  @override
  Stream<bool> get updateComplete =>
      _updateCompleteState ??= _mapToUpdateCompleteState();

  Stream<String> _mapToImagePathState();

  Stream<String> _mapToNameState();

  Stream<BreedType> _mapToBreedState();

  Stream<Gender> _mapToGenderState();

  Stream<String> _mapToCharacteristicsState();

  Stream<bool> _mapToShowErrorsState();

  Stream<bool> _mapToIsSaveEnabledState();

  Stream<bool> _mapToUpdateCompleteState();

  @override
  PuppyManageEvents get events => this;

  @override
  PuppyManageStates get states => this;

  @override
  void dispose() {
    _$markAsFavoriteEvent.close();
    _$setNameEvent.close();
    _$setCharacteristicsEvent.close();
    _$setGenderEvent.close();
    _$setBreedEvent.close();
    _$setImageEvent.close();
    _$savePuppyEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [PuppyManageEvents.markAsFavorite] event
class _MarkAsFavoriteEventArgs {
  const _MarkAsFavoriteEventArgs(
      {required this.puppy, required this.isFavorite});

  final Puppy puppy;

  final bool isFavorite;
}
