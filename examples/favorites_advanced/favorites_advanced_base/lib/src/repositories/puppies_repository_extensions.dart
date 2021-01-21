part of 'puppies_repository.dart';

extension ExtendImagePicker on ImagePicker {
  Future<PickedFile> pickPicture({
    @required ImagePickerActions source,
    bool frontCamera = false,
  }) async {
    PickedFile pickedFile;

    switch (source) {
      case ImagePickerActions.camera:
        pickedFile = await getImage(
          source: ImageSource.camera,
          preferredCameraDevice:
              frontCamera ? CameraDevice.front : CameraDevice.rear,
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
