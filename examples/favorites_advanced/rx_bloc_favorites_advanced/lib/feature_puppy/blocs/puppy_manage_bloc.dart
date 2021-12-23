import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/repositories/paginated_puppies_repository.dart';
import '../validators/puppy_validator.dart';

part 'puppy_manage_bloc.rxb.g.dart';
part 'puppy_manage_bloc_extensions.dart';

abstract class PuppyManageEvents {
  void markAsFavorite({required Puppy puppy, required bool isFavorite});

  void setName(String newName);

  void setCharacteristics(String newCharacteristics);

  void setGender(Gender gender);

  void setBreed(BreedType breedType);

  void setImage(ImagePickerAction source);

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
    PaginatedPuppiesRepository puppiesRepository,
    CoordinatorBlocType coordinatorBloc, {
    PuppyValidator validator = const PuppyValidator(),
    Puppy? puppy,
  })  : _puppy = puppy,
        _puppyValidator = validator,
        _puppiesRepository = puppiesRepository,
        _coordinatorBloc = coordinatorBloc {
    //For a more detailed explanation reference this article:
    //https://medium.com/prime-holding-jsc/building-complex-apps-in-flutter-with-the-power-of-reactive-programming-54a38fbc0cde
    _$markAsFavoriteEvent
        //use an extension which handles marking the puppy as favourite
        //without delay between the event and the response
        .markPuppyAsFavorite(puppiesRepository, this)
        //notify the coordinator bloc that the puppy has been changed
        .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy))
        .bind(_lastUpdatedPuppy)
        .disposedBy(_compositeSubscription);
  }

  final Puppy? _puppy;

  final PuppyValidator _puppyValidator;
  final PaginatedPuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBloc;

  final _lastUpdatedPuppy = BehaviorSubject<Puppy>();
  final _favoritePuppyError = PublishSubject<Exception>();

  @override
  Stream<String> get error =>
      Rx.merge([errorState, _favoritePuppyError]).mapToString().share();

  @override
  Stream<bool> get isLoading => loadingState.shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToImagePathState() => _$setImageEvent
      .throttleTime(const Duration(seconds: 2))
      .pickImagePath(_puppiesRepository)
      .startWith(_puppy?.asset ?? '')
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
      .validateAllFields(this)
      .map((valid) => !valid)
      .startWith(false)
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsSaveEnabledState() =>
      _hasChanges().startWith(false).shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToUpdateCompleteState() => _$savePuppyEvent
      //if all fields are valid
      .validateAllFields(this)
      .where((allFieldsAreValid) => allFieldsAreValid)
      //try to save the puppy
      .savePuppy(this)
      //make this bloc handle all loading or error events from savePuppy
      .setResultStateHandler(this)
      //if saving the puppy was successful
      .whereSuccess()
      //notify the coordinator bloc that the puppy has been changed
      .doOnData(_coordinatorBloc.events.puppyUpdated)
      .mapTo(true)
      .shareReplay(maxSize: 1);

  @override
  void dispose() {
    _favoritePuppyError.close();
    _lastUpdatedPuppy.close();
    super.dispose();
  }
}
