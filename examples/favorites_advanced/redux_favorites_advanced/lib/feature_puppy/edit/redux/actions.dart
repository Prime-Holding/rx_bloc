import 'package:favorites_advanced_base/models.dart';

class SubmitAttemptedAction {}

class EditLoadingAction {}

class UpdateSucceededAction {}

class UpdateFailedAction {
  UpdateFailedAction({required this.error});

  final String error;
}

class UpdatePuppyAction {
  UpdatePuppyAction({required this.puppy});

  final Puppy puppy;
}

class ImagePickAction {
  ImagePickAction({required this.source});

  final ImagePickerAction source;
}

class ImagePathAction {
  ImagePathAction({required this.imagePath});

  final String imagePath;
}

class EditPuppyAction {
  EditPuppyAction({required this.puppy});

  final Puppy puppy;
}

class NameAction {
  NameAction({required this.name});

  final String name;
}

class BreedAction {
  BreedAction({required this.breedType});

  final BreedType breedType;
}

class GenderAction {
  GenderAction({required this.gender});

  final Gender gender;
}

class CharacteristicsAction {
  CharacteristicsAction({required this.characteristics});

  final String characteristics;
}
