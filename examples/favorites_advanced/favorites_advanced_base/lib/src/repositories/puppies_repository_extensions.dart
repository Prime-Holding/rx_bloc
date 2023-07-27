part of 'puppies_repository.dart';

extension ExtendImagePicker on ImagePicker {
  Future<XFile?> pickPicture({
    required ImagePickerAction source,
    CameraDevice preferredCamera = CameraDevice.rear,
  }) async {
    XFile? pickedFile;

    switch (source) {
      case ImagePickerAction.camera:
        pickedFile = (await pickImage(
          source: ImageSource.camera,
          // preferredCameraDevice: preferredCamera,
        ));
        break;
      case ImagePickerAction.gallery:
        pickedFile = await pickImage(
          source: ImageSource.gallery,
        );
        break;
    }

    if (Platform.isAndroid) {
      final lostData = await _retrieveLostData();

      if (lostData != null && lostData.path.isNotEmpty) {
        pickedFile = XFile(lostData.path);
      }
    }

    // The user may cancel photo selection (on Android) pressing
    // the back button. In that case, don't return a file
    if (pickedFile == null) return null;

    return pickedFile;
  }

  Future<XFile?> _retrieveLostData() async {
    final response = await retrieveLostData();

    if (response.file != null && response.type == RetrieveType.image) {
      return response.file;
    }

    return XFile('');
  }
}
