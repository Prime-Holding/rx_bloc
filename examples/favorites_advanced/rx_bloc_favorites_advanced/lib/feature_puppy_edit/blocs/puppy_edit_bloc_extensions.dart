part of 'puppy_edit_bloc.dart';

extension _UpdatePuppyExtension on PuppyEditBloc {
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
      .switchMap((args) => verifyAndUpdatePuppy(args).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();

  Future<Puppy> verifyAndUpdatePuppy(_UpdatePuppyData data) async {
    // TODO: Data verification goes here

    final pup = data.puppy;
    final puppyToUpdate = pup.copyWith(
      name: data.name ?? pup.name,
      breedCharacteristics: data.characteristics ?? pup.breedCharacteristics,
      gender: data.gender ?? pup.gender,
      breedType: data.breed ?? pup.breedType,
      asset: data.imagePath ?? pup.asset,
    );

    return _puppiesRepository.updatePuppy(pup.id, puppyToUpdate);
  }

  Stream<bool> isSavingAvailable() => Rx.combineLatest6(
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

extension ExtendImagePicker on ImagePicker {
  Future<PickedFile> pickPicture({
    @required ImagePickerActions source,
    bool isProfile = false,
  }) async {
    PickedFile pickedFile;

    switch (source) {
      case ImagePickerActions.camera:
        pickedFile = await getImage(
          source: ImageSource.camera,
          preferredCameraDevice:
              isProfile ? CameraDevice.front : CameraDevice.rear,
        );
        break;
      case ImagePickerActions.gallery:
        pickedFile = await getImage(
          source: ImageSource.gallery,
        );
        break;
    }

    if (Platform.isAndroid) {
      final lostData = await _retrieveLostData();

      if (lostData != null &&
          lostData.path != null &&
          lostData.path.isNotEmpty) {
        pickedFile = PickedFile(lostData.path);
      }
    }

    // The user may cancel photo selection (on Android) pressing
    // the back button. In that case, don't return a file
    if (pickedFile == null) return null;

    return pickedFile;
  }

  Future<PickedFile> _retrieveLostData() async {
    final response = await getLostData();

    if (response.file != null && response.type == RetrieveType.image) {
      return response.file;
    }

    return PickedFile('');
  }
}
