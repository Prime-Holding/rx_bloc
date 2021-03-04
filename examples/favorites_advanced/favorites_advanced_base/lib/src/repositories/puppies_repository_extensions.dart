part of 'puppies_repository.dart';

extension ExtendImagePicker on ImagePicker {
  Future<PickedFile?> pickPicture({
    required ImagePickerAction source,
    CameraDevice preferredCamera = CameraDevice.rear,
  }) async {
    PickedFile? pickedFile;

    switch (source) {
      case ImagePickerAction.camera:
        pickedFile = await getImage(
          source: ImageSource.camera,
          preferredCameraDevice: preferredCamera,
        );
        break;
      case ImagePickerAction.gallery:
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

  Future<PickedFile?> _retrieveLostData() async {
    final response = await getLostData();

    if (response.file != null && response.type == RetrieveType.image) {
      return response.file;
    }

    return PickedFile('');
  }
}
