import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_bloc.rxb.g.dart';
part 'puppy_edit_bloc_extensions.dart';
part 'puppy_edit_bloc_models.dart';

abstract class PuppyEditBlocEvents {
  void setEditingPuppy(Puppy puppy);

  void updateName(String newName);

  void updateBreed(BreedTypes breedType);

  void updateGender(Gender gender);

  void updateCharacteristics(String newCharacteristics);

  void pickImage(ImagePickerActions source);

  void updatePuppy();

  // Remove this
  void updatePuppyOld(Puppy newPuppy, Puppy oldPuppy);
}

abstract class PuppyEditBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get successfulUpdate;

  @RxBlocIgnoreState()
  Stream<bool> get processingUpdate;

  @RxBlocIgnoreState()
  Stream<String> get updateError;

  @RxBlocIgnoreState()
  Stream<String> get pickedImagePath;

  @RxBlocIgnoreState()
  Stream<bool> get isSaveEnabled;

  @RxBlocIgnoreState()
  Stream<Gender> get selectedGender;

  @RxBlocIgnoreState()
  Stream<BreedTypes> get selectedBreed;
}

@RxBloc()
class PuppyEditBloc extends $PuppyEditBloc {
  PuppyEditBloc(
    PuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  )   : _puppiesRepository = repository,
        _coordinatorBlocType = coordinatorBloc,
        _imagePicker = ImagePicker() {
    _$updateGenderEvent.bind(_genderSubject).disposedBy(_subscriptions);
    _$setEditingPuppyEvent.bind(_puppySubject).disposedBy(_subscriptions);
    _$updateBreedEvent.bind(_breedSubject).disposedBy(_subscriptions);
    _$updateNameEvent.bind(_nameSubject).disposedBy(_subscriptions);
    _$updateCharacteristicsEvent
        .bind(_characteristicsSubject)
        .disposedBy(_subscriptions);

    _$pickImageEvent
        .throttleTime(const Duration(seconds: 2))
        .where((event) => event != null)
        .switchMap((source) => _imagePicker
            .pickPicture(source: source, isProfile: true)
            .asStream())
        .map((pickedImage) => pickedImage?.path ?? '')
        .bind(_imagePath)
        .disposedBy(_subscriptions);
  }

  final ImagePicker _imagePicker;

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBlocType;
  final _subscriptions = CompositeSubscription();

  final _imagePath = BehaviorSubject<String>.seeded(null);
  final _puppySubject = BehaviorSubject<Puppy>.seeded(null);
  final _genderSubject = BehaviorSubject<Gender>.seeded(null);
  final _breedSubject = BehaviorSubject<BreedTypes>.seeded(null);
  final _nameSubject = BehaviorSubject<String>.seeded(null);
  final _characteristicsSubject = BehaviorSubject<String>.seeded(null);

  @override
  void dispose() {
    _subscriptions.dispose();

    _imagePath.close();
    _puppySubject.close();
    _genderSubject.close();
    _breedSubject.close();
    _nameSubject.close();
    _characteristicsSubject.close();

    super.dispose();
  }

  @override
  Stream<bool> get successfulUpdate => editPuppy().doOnData((data) {
        _coordinatorBlocType.events.puppyUpdated(data);
      }).map((value) => value != null);

  @override
  Stream<bool> get processingUpdate => loadingState;

  @override
  Stream<String> get updateError => errorState.mapToString();

  @override
  Stream<bool> get isSaveEnabled => isSavingAvailable();

  @override
  Stream<String> get pickedImagePath => _imagePath;

  @override
  Stream<Gender> get selectedGender => _genderSubject;

  @override
  Stream<BreedTypes> get selectedBreed => _breedSubject;
}
