import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/validators/puppy_validator.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';

part 'puppy_manage_bloc.rxb.g.dart';
part 'puppy_manage_bloc_extensions.dart';

abstract class PuppyManageEvents {
  void markAsFavorite({Puppy puppy, bool isFavorite});

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void updateName(String newName);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void updateCharacteristics(String newCharacteristics);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: Gender.None)
  void updateGender(Gender gender);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: BreedType.None)
  void updateBreed(BreedType breedType);

  void pickImage(ImagePickerActions source);

  void updatePuppy();
}

abstract class PuppyManageStates {
  Stream<bool> get isSaveEnabled;

  Stream<String> get imagePath;

  Stream<Gender> get gender;

  Stream<BreedType> get breed;

  Stream<String> get name;

  Stream<String> get characteristics;

  Stream<Result<void>> get updateStatus;

  Stream<bool> get processingUpdate;

  //used to be used for popping the edit page, figure out a new solution
  Stream<bool> get successfulUpdate;

  Stream<String> get updateError;

  Stream<bool> get showErrors;

  @RxBlocIgnoreState()
  Stream<Puppy> get puppy;

  @RxBlocIgnoreState()
  Stream<String> get error;
}

@RxBloc()
class PuppyManageBloc extends $PuppyManageBloc {
  PuppyManageBloc(
    PuppiesRepository puppiesRepository,
    CoordinatorBlocType coordinatorBloc, {
    PuppyValidator validator,
    Puppy puppy,
  })  : _puppyValidator = validator,
        _puppiesRepository = puppiesRepository,
        _coordinatorBlocType = coordinatorBloc {
    if (puppy != null) {
      _editingPuppy.add(puppy);
      updateName(puppy.name);
      updateCharacteristics(puppy.breedCharacteristics);
      // updateGender(puppy.gender);
      // updateBreed(puppy.breedType);
    }

    _$markAsFavoriteEvent
        .markPuppyAsFavorite(puppiesRepository, this)
        .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy))
        .bind(_lastUpdatedPuppy)
        .disposedBy(_compositeSubscription);
  }

  final PuppyValidator _puppyValidator;
  final PuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBlocType;

  final _lastUpdatedPuppy = BehaviorSubject<Puppy>();
  final _compositeSubscription = CompositeSubscription();
  final _favoritePuppyError = PublishSubject<Exception>();

  final _editingPuppy = BehaviorSubject<Puppy>();

  @override
  Stream<Puppy> get puppy => _editingPuppy;

  @override
  Stream<String> get error => Rx.merge([errorState, _favoritePuppyError])
      .map((exc) => exc.toString())
      .share();

  @override
  Stream<String> _mapToNameState() => _$updateNameEvent
      .validateField(_puppyValidator.validatePuppyName)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToCharacteristicsState() => _$updateCharacteristicsEvent
      .validateField(_puppyValidator.validatePuppyCharacteristics)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToImagePathState() => _$pickImageEvent
      .throttleTime(const Duration(seconds: 2))
      .pickImagePath(_puppiesRepository)
      .startWith(_editingPuppy.value.asset);

  @override
  Stream<bool> _mapToProcessingUpdateState() => BehaviorSubject.seeded(false);

  @override
  Stream<bool> _mapToShowErrorsState() => _$updatePuppyEvent
      .switchMap((_) => _validateAllFields())
      .startWith(false)
      .shareReplay(maxSize: 1);

  Stream<bool> _validateAllFields() =>
      Rx.combineLatest3<String, String, Gender, bool>(
        name,
        characteristics,
        gender,
        (name, characteristics, gender) => false,
      ).onErrorReturn(true);

  @override
  Stream<BreedType> _mapToBreedState() => _$updateBreedEvent
      .validateField(_puppyValidator.validatePuppyBreed)
      .shareReplay(maxSize: 1);

  @override
  Stream<Gender> _mapToGenderState() => _$updateGenderEvent
      .validateField(_puppyValidator.validatePuppyGender)
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsSaveEnabledState() => BehaviorSubject.seeded(true);

  @override
  Stream<bool> _mapToSuccessfulUpdateState() {
    // TODO: implement _mapToSuccessfulUpdateState
    throw UnimplementedError();
  }

  @override
  Stream<String> _mapToUpdateErrorState() {
    // TODO: implement _mapToUpdateErrorState
    throw UnimplementedError();
  }

  @override
  Stream<Result<void>> _mapToUpdateStatusState() {
    // TODO: implement _mapToUpdateStatusState
    throw UnimplementedError();
  }

  @override
  void dispose() {
    _favoritePuppyError.close();
    _lastUpdatedPuppy.close();
    _compositeSubscription.dispose();
    _editingPuppy.close();
    super.dispose();
  }
}
