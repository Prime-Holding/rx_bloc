import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyEditingController extends GetxController {
  PuppyEditingController(
      this._repository, this._mediatorController, this._puppy);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;
  final Puppy _puppy;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController nameController, characteristicsController;
  final isLoading = false.obs;
  final asset = ''.obs;
  final _name = ''.obs;
  final _characteristics = ''.obs;
  late Puppy _editedPuppy;
  final _gender = Gender.None.obs;
  final _breed = BreedType.None.obs;

  static const invalidValue = 'Please enter valid values in all fields!';
  static const successfullySaved = 'Puppy is saved successfully.';

  Gender get genderValue => _gender.value;
  BreedType get breed => _breed.value;

  @override
  void onInit() {
    _initFields();
    super.onInit();
  }

  void _initFields() {
    asset(_puppy.asset);
    _name(_puppy.name);
    _characteristics(_puppy.breedCharacteristics);
    _editedPuppy = _puppy;
    _gender(_puppy.gender);
    _breed(_puppy.breedType);

    nameController = TextEditingController(text: _puppy.name);
    characteristicsController =
        TextEditingController(text: _puppy.breedCharacteristics);
  }

  bool isSaveEnabled() =>
      _name.value != _puppy.name ||
      _characteristics.value != _puppy.breedCharacteristics ||
      _gender.value != _puppy.gender ||
      _breed.value != _puppy.breedType;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name must not be empty.';
    }
    if (value.trim().length > 30) {
      return 'Name too long.';
    }
  }

  String? validateCharacteristics(String? value) {
    if (value == null || value.isEmpty) {
      return 'Characteristics must not be empty.';
    }
    if (value.trim().length > 250) {
      return 'Characteristics must not exceed 250 characters .';
    }
  }

  void changeLocalName(String value) => _name(value);

  void setName(String value) =>
      _editedPuppy = _editedPuppy.copyWith(name: value);

  void changeLocalCharacteristics(String value) => _characteristics(value);

  void setCharacteristics(String value) =>
      _editedPuppy = _editedPuppy.copyWith(breedCharacteristics: value);

  void handleGenderChanging(Gender value) {
    _gender(value);
    _editedPuppy = _editedPuppy.copyWith(gender: value);
  }

  void handleBreedChanging(BreedType value) {
    _breed(value);
    _editedPuppy = _editedPuppy.copyWith(breedType: value);
    print(value.toString());
  }

  Future<String> savePuppy() async {
    isLoading(true);
    final isValid = globalFormKey.currentState!.validate();
    if (!isValid) {
      isLoading(false);
      return invalidValue;
    }
    try {
      globalFormKey.currentState!.save();
      final updatedPuppy =
          await _repository.updatePuppy(_editedPuppy.id, _editedPuppy);
      _mediatorController.puppyUpdated(updatedPuppy);
      await Future.delayed(const Duration(milliseconds: 1500));
      isLoading(false);
      return successfullySaved;
    } catch (e) {
      _mediatorController.puppyUpdated(_puppy);
      isLoading(false);
      return e.toString().substring(10);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    characteristicsController.dispose();
    super.onClose();
  }
}
