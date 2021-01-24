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
  void setName(String newName);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setCharacteristics(String newCharacteristics);

  void setGender(Gender gender);

  void setBreed(BreedType breedType);

  void setImage(ImagePickerActions source);

  void savePuppy();
}

abstract class PuppyManageStates {
  Stream<String> get imagePath;

  Stream<String> get name;

  Stream<BreedType> get breed;

  Stream<Gender> get gender;

  Stream<String> get characteristics;

  Stream<bool> get showErrors;

  Stream<bool> get isSaveEnabled;

  Stream<bool> get updateComplete;

  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

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
  })  : _puppy = puppy,
        _puppyValidator = validator,
        _puppiesRepository = puppiesRepository,
        _coordinatorBlocType = coordinatorBloc {
    _$markAsFavoriteEvent
        .markPuppyAsFavorite(puppiesRepository, this)
        .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy))
        .bind(_lastUpdatedPuppy)
        .disposedBy(_compositeSubscription);
  }

  final Puppy _puppy;

  final PuppyValidator _puppyValidator;
  final PuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBlocType;

  final _lastUpdatedPuppy = BehaviorSubject<Puppy>();
  final _compositeSubscription = CompositeSubscription();
  final _favoritePuppyError = PublishSubject<Exception>();

  @override
  Stream<String> get error =>
      Rx.merge([errorState, _favoritePuppyError]).mapToString().share();

  @override
  Stream<bool> get isLoading =>
      loadingState.startWith(false).shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToImagePathState() => _$setImageEvent
      .throttleTime(const Duration(seconds: 2))
      .pickImagePath(_puppiesRepository)
      .startWith(_puppy.asset)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToNameState() => _$setNameEvent
      .startWith(_puppy?.name ?? '')
      .validateField(_puppyValidator.validatePuppyName)
      .shareReplay(maxSize: 1);

  @override
  Stream<BreedType> _mapToBreedState() => _$setBreedEvent
      .startWith(_puppy?.breedType ?? BreedType.None)
      .validateField(_puppyValidator.validatePuppyBreed)
      .shareReplay(maxSize: 1);

  @override
  Stream<Gender> _mapToGenderState() => _$setGenderEvent
      .startWith(_puppy?.gender ?? Gender.None)
      .validateField(_puppyValidator.validatePuppyGender)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToCharacteristicsState() => _$setCharacteristicsEvent
      .startWith(_puppy?.displayCharacteristics ?? '')
      .validateField(_puppyValidator.validatePuppyCharacteristics)
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToShowErrorsState() => _$savePuppyEvent
      .switchMap((_) => _validateAllFields().map((event) => !event))
      .startWith(false)
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsSaveEnabledState() =>
      _hasChanges().startWith(false).shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToUpdateCompleteState() => _$savePuppyEvent
      .switchMap((_) => _validateAllFields())
      .where((allFieldsAreValid) => allFieldsAreValid)
      .switchMap((_) => _savePuppy())
      .setResultStateHandler(this)
      .whereSuccess()
      .mapTo(true)
      .shareReplay(maxSize: 1);

  @override
  void dispose() {
    _favoritePuppyError.close();
    _lastUpdatedPuppy.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
