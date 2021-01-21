import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_bloc.rxb.g.dart';
part 'puppy_edit_bloc_extensions.dart';
part 'puppy_edit_bloc_models.dart';

abstract class PuppyEditBlocEvents {
  void setEditingPuppy(Puppy puppy);

  void updateName(String newName);
  void updateCharacteristics(String newCharacteristics);
  void updateGender(Gender gender);
  void updateBreed(BreedType breedType);
  void pickImage(ImagePickerActions source);

  void updatePuppy();
}

abstract class PuppyEditBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get isSaveEnabled;
  @RxBlocIgnoreState()
  Stream<bool> get processingUpdate;
  @RxBlocIgnoreState()
  Stream<bool> get successfulUpdate;

  @RxBlocIgnoreState()
  Stream<String> get pickedImagePath;
  @RxBlocIgnoreState()
  Stream<Gender> get selectedGender;
  @RxBlocIgnoreState()
  Stream<BreedType> get selectedBreed;

  @RxBlocIgnoreState()
  Stream<String> get updateError;
  @RxBlocIgnoreState()
  Stream<String> get nameError;
  @RxBlocIgnoreState()
  Stream<String> get characteristicsError;
}

@RxBloc()
class PuppyEditBloc extends $PuppyEditBloc {
  PuppyEditBloc(
    PuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  )   : _puppiesRepository = repository,
        _coordinatorBlocType = coordinatorBloc {
    _bindEventsToStates();
  }

  final _maxNameLength = 30;
  final _maxCharacteristicsLength = 250;

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBlocType;
  final _subscriptions = CompositeSubscription();

  final _imagePath = BehaviorSubject<String>.seeded(null);
  final _puppySubject = BehaviorSubject<Puppy>.seeded(null);
  final _genderSubject = BehaviorSubject<Gender>.seeded(null);
  final _breedSubject = BehaviorSubject<BreedType>.seeded(null);
  final _nameSubject = BehaviorSubject<String>.seeded(null);
  final _characteristicsSubject = BehaviorSubject<String>.seeded(null);

  final _nameErrorSubject = BehaviorSubject<String>.seeded(null);
  final _characteristicsErrorSubject = BehaviorSubject<String>.seeded(null);

  @override
  void dispose() {
    _subscriptions.dispose();

    _imagePath.close();
    _puppySubject.close();
    _genderSubject.close();
    _breedSubject.close();
    _nameSubject.close();
    _characteristicsSubject.close();
    _nameErrorSubject.close();
    _characteristicsErrorSubject.close();

    super.dispose();
  }

  @override
  Stream<bool> get successfulUpdate => editPuppy().doOnData((data) {
        if (data != null) _coordinatorBlocType.events.puppyUpdated(data);
      }).map((value) => value != null);

  @override
  Stream<bool> get processingUpdate => loadingState;

  @override
  Stream<String> get updateError => errorState.mapToString();

  @override
  Stream<bool> get isSaveEnabled => _isSavingAvailable();

  @override
  Stream<String> get pickedImagePath => _imagePath;

  @override
  Stream<Gender> get selectedGender => _genderSubject;

  @override
  Stream<BreedType> get selectedBreed => _breedSubject;

  @override
  Stream<String> get nameError => _nameErrorSubject;

  @override
  Stream<String> get characteristicsError => _characteristicsErrorSubject;
}
