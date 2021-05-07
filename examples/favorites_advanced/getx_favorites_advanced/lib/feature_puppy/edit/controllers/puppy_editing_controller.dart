import 'package:flutter/material.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyEditingController extends GetxController {
  PuppyEditingController(this._mediatorController, this._puppy);
  final MediatorController _mediatorController;
  final Puppy _puppy;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController nameController, characteristicsController;
  final isLoading = false.obs;
  final asset = ''.obs;
  final _name = ''.obs;
  final _characteristics = ''.obs;
  Puppy? _editedPuppy;
  final radioGroup = 1.obs;

  @override
  void onInit() {
    _initFields();
    super.onInit();
  }

  void _initFields() {
    asset(_puppy.asset);
    _name(_puppy.name);
    _characteristics(_puppy.displayCharacteristics);
    _editedPuppy = _puppy;
    radioGroup(_puppy.gender.index);
    nameController = TextEditingController(text: _puppy.displayName);
    characteristicsController =
        TextEditingController(text: _puppy.displayCharacteristics);
  }

  bool isSaveEnabled() =>
      _name.value != _puppy.name
        || _characteristics.value != _puppy.displayCharacteristics
        || radioGroup.value != _puppy.gender.index;

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
    _editedPuppy = _editedPuppy!.copyWith(name: value, displayName: value);


  void changeLocalCharacteristics(String value) => _characteristics(value);


  void setCharacteristics(String value) =>
    _editedPuppy = _editedPuppy!.copyWith(displayCharacteristics: value);


  void handleGenderChanging(int value){
    radioGroup(value);
    _editedPuppy = _editedPuppy!.copyWith(gender: Gender.values[value]);
  }

  Future<bool> savePuppy() async {
    isLoading(true);
    final isValid = globalFormKey.currentState!.validate();
    if(!isValid){
      isLoading(false);
      return false;
    }
    globalFormKey.currentState!.save();
    _mediatorController.puppyUpdated(_editedPuppy!);
    await Future.delayed(const Duration(milliseconds: 2000));
    isLoading(false);
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    characteristicsController.dispose();
    super.onClose();
  }

}
