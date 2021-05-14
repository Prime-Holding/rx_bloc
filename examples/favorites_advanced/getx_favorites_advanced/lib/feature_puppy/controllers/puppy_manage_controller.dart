import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';

class PuppyManageController extends GetxController {
  PuppyManageController(this._repository, this._coordinatorController,
      {Puppy? puppy})
      : _puppy = puppy;

  final PuppiesRepository _repository;
  final CoordinatorController _coordinatorController;
  late final Puppy? _puppy;

  final isLoading = false.obs;
  bool hasErrors = false;
  final validateEnabled = false.obs;
  final asset = ''.obs;
  final _name = ''.obs;
  final _characteristics = ''.obs;
  late Puppy _editedPuppy;
  final _gender = Gender.None.obs;
  final _breed = BreedType.None.obs;

  static const invalidValue = 'Please enter valid values in all fields!';
  static const successfullySaved = 'Puppy is saved successfully.';
  static const emptyName = 'Name must not be empty.';
  static const tooLongName = 'Name too long.';
  static const emptyCharacteristics = 'Characteristics must not be empty.';
  static const tooLongCharacteristics =
      'Characteristics must not exceed 250 characters.';

  Puppy get editedPuppy => _editedPuppy;
  String get name => _name.value;
  String get characteristics => _characteristics.value;
  Gender get gender => _gender.value;
  BreedType get breed => _breed.value;

  @override
  void onInit() {
    if (_puppy != null) {
      _initFields();
    }
    super.onInit();
  }

  void _initFields() {
    asset(_puppy!.asset);
    _name(_puppy!.name);
    _characteristics(_puppy!.breedCharacteristics);
    _editedPuppy = _puppy!;
    _gender(_puppy!.gender);
    _breed(_puppy!.breedType);
  }

  bool isSaveEnabled() =>
      _name.value != _puppy!.name ||
      _characteristics.value != _puppy!.breedCharacteristics ||
      _gender.value != _puppy!.gender ||
      _breed.value != _puppy!.breedType;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      hasErrors = true;
      return emptyName;
    }
    if (value.trim().length > 30) {
      hasErrors = true;
      return tooLongName;
    }
    hasErrors = false;
  }

  String? validateCharacteristics(String? value) {
    if (value == null || value.isEmpty) {
      hasErrors = true;
      return emptyCharacteristics;
    }
    if (value.trim().length > 250) {
      hasErrors = true;
      return tooLongCharacteristics;
    }
    hasErrors = false;
  }

  void changeLocalName(String value) => _name(value);

  void setName(String value) =>
      _editedPuppy = _editedPuppy.copyWith(name: value);

  void changeLocalCharacteristics(String value) => _characteristics(value);

  void setCharacteristics(String value) =>
      _editedPuppy = _editedPuppy.copyWith(breedCharacteristics: value);

  void handleGenderChanging(Gender value) {
    if(value != _editedPuppy.gender){
      _gender(value);
      _editedPuppy = _editedPuppy.copyWith(gender: value);
    }
  }

  void handleBreedChanging(BreedType value) {
    if(value != _editedPuppy.breedType){
      _breed(value);
      _editedPuppy = _editedPuppy.copyWith(breedType: value);
    }
  }

  Future<String> savePuppy() async {
    isLoading(true);
    enableValidation();
    if (hasErrors) {
      isLoading(false);
      return invalidValue;
    }
    try {
      final updatedPuppy =
          await _repository.updatePuppy(_editedPuppy.id, _editedPuppy);
      _coordinatorController.puppyUpdated(updatedPuppy);
      isLoading(false);
      return successfullySaved;
    } catch (e) {
      _coordinatorController.puppyUpdated(_puppy!);
      isLoading(false);
      return e.toString().substring(10);
    }
  }

  void enableValidation(){
    validateEnabled(true);

  }

  Future<void> markAsFavorite(
      {required Puppy puppy, required bool isFavorite}) async {
    _coordinatorController.puppyUpdated(puppy.copyWith(isFavorite: isFavorite));
    try {
      await _repository.favoritePuppy(puppy, isFavorite: isFavorite);
    } catch (e) {
      await Get.showSnackbar(GetBar(
        message: e.toString().substring(10),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        duration: const Duration(seconds: 2),
      ));
      _coordinatorController.puppyUpdated(puppy);
    }
  }
}
