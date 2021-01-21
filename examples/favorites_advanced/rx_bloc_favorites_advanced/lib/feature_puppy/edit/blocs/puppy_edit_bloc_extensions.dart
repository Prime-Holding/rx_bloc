part of 'puppy_edit_bloc.dart';

extension _UpdatePuppyExtension on PuppyEditBloc {
  void _bindEventsToStates() {
    _$updateGenderEvent.bind(_genderSubject).disposedBy(_subscriptions);
    _$setEditingPuppyEvent.bind(_puppySubject).disposedBy(_subscriptions);
    _$updateBreedEvent.bind(_breedSubject).disposedBy(_subscriptions);
    _$updateNameEvent.bind(_nameSubject).disposedBy(_subscriptions);
    _$updateCharacteristicsEvent
        .bind(_characteristicsSubject)
        .disposedBy(_subscriptions);
  }

  Stream<Puppy> editPuppy() => _$updatePuppyEvent
      .withLatestFrom6(
          _nameSubject,
          _characteristicsSubject,
          _genderSubject,
          _breedSubject,
          _imagePath,
          _puppySubject,
          (_, name, characteristics, gender, breed, imagePath, puppy) =>
              _UpdatePuppyData(
                name: name,
                characteristics: characteristics,
                imagePath: imagePath,
                gender: gender,
                breed: breed,
                puppy: puppy,
              ))
      .switchMap((args) => _verifyAndUpdatePuppy(args).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();

  void _resetErrorStreams() {
    _nameErrorSubject.add(null);
    _characteristicsErrorSubject.add(null);
  }

  Future<Puppy> _verifyAndUpdatePuppy(_UpdatePuppyData data) async {
    _resetErrorStreams();

    // Verify if the entered data is valid
    if (!_dataIsValid(data)) return Future.value(null);

    // Now update the puppy
    final pup = data.puppy;
    final puppyToUpdate = pup.copyWith(
      name: data.name?.trim() ?? pup.name,
      breedCharacteristics:
          data.characteristics?.trim() ?? pup.breedCharacteristics,
      gender: data.gender ?? pup.gender,
      breedType: data.breed ?? pup.breedType,
      asset: data.imagePath ?? pup.asset,
    );

    return _puppiesRepository.updatePuppy(pup.id, puppyToUpdate);
  }

  bool _dataIsValid(_UpdatePuppyData data) {
    var isValid = true;
    final pup = data.puppy;
    // Verify name length
    final editedName = (data.name ?? pup.name).trim();
    if (editedName.isEmpty || editedName.length > _maxNameLength) {
      if (editedName.isEmpty) _nameErrorSubject.add('Name cannot be empty.');
      if (editedName.length > _maxNameLength) {
        _nameErrorSubject.add('Name too long.');
      }
      isValid = false;
    }

    // Verify characteristics length
    final editedDetails =
        (data.characteristics ?? pup.breedCharacteristics).trim();
    if (editedDetails.isEmpty ||
        editedDetails.length > _maxCharacteristicsLength) {
      if (editedDetails.isEmpty) {
        _characteristicsErrorSubject.add('Characteristics cannot be empty.');
      }
      if (editedDetails.length > _maxNameLength) {
        _characteristicsErrorSubject.add('Characteristics exceed max length of'
            ' $_maxCharacteristicsLength characters.');
      }
      isValid = false;
    }

    return isValid;
  }

  Stream<bool> _isSavingAvailable() => Rx.combineLatest6(
        _puppySubject,
        _nameSubject,
        _genderSubject,
        _breedSubject,
        _characteristicsSubject,
        _imagePath,
        (puppy, name, gender, breed, characteristics, imagePath) =>
            (puppy.name != name && name != null) ||
            (puppy.breedType != breed && breed != null) ||
            (puppy.gender != gender && gender != null) ||
            (puppy.breedCharacteristics != characteristics &&
                characteristics != null) ||
            imagePath != null,
      );
}

extension _ExceptionExtensions on Stream<Exception> {
  Stream<String> mapToString() =>
      map((e) => e.toString().replaceAll('Exception:', ''));
}
