// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_manage_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class PuppyManageBlocType extends RxBlocTypeBase {
  PuppyManageEvents get events;
  PuppyManageStates get states;
}

/// [$PuppyManageBloc] extended by the [PuppyManageBloc]
/// @nodoc
abstract class $PuppyManageBloc extends RxBlocBase
    implements PuppyManageEvents, PuppyManageStates, PuppyManageBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [markAsFavorite]
  final _$markAsFavoriteEvent =
      PublishSubject<({Puppy puppy, bool isFavorite})>();

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
  late final Stream<String> _imagePathState = _mapToImagePathState();

  /// The state of [name] implemented in [_mapToNameState]
  late final Stream<String> _nameState = _mapToNameState();

  /// The state of [breed] implemented in [_mapToBreedState]
  late final Stream<BreedType> _breedState = _mapToBreedState();

  /// The state of [gender] implemented in [_mapToGenderState]
  late final Stream<Gender> _genderState = _mapToGenderState();

  /// The state of [characteristics] implemented in [_mapToCharacteristicsState]
  late final Stream<String> _characteristicsState =
      _mapToCharacteristicsState();

  /// The state of [showErrors] implemented in [_mapToShowErrorsState]
  late final Stream<bool> _showErrorsState = _mapToShowErrorsState();

  /// The state of [isSaveEnabled] implemented in [_mapToIsSaveEnabledState]
  late final Stream<bool> _isSaveEnabledState = _mapToIsSaveEnabledState();

  /// The state of [updateComplete] implemented in [_mapToUpdateCompleteState]
  late final Stream<bool> _updateCompleteState = _mapToUpdateCompleteState();

  @override
  void markAsFavorite({
    required Puppy puppy,
    required bool isFavorite,
  }) =>
      _$markAsFavoriteEvent.add((
        puppy: puppy,
        isFavorite: isFavorite,
      ));

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
  Stream<String> get imagePath => _imagePathState;

  @override
  Stream<String> get name => _nameState;

  @override
  Stream<BreedType> get breed => _breedState;

  @override
  Stream<Gender> get gender => _genderState;

  @override
  Stream<String> get characteristics => _characteristicsState;

  @override
  Stream<bool> get showErrors => _showErrorsState;

  @override
  Stream<bool> get isSaveEnabled => _isSaveEnabledState;

  @override
  Stream<bool> get updateComplete => _updateCompleteState;

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

// ignore: unused_element
typedef _MarkAsFavoriteEventArgs = ({Puppy puppy, bool isFavorite});
