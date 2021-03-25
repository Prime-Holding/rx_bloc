import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/base_controller.dart';

class PuppyManageController extends GetxController {
  PuppyManageController(
      PuppiesRepository repository, BaseController baseController) {
    _repository = repository;
    _baseController = baseController;
  }

  late PuppiesRepository _repository;
  late BaseController _baseController;
  final puppyToUpdate = <Puppy>[].obs;
  final onError = <String>[].obs;

  Future<void> favoritePuppy(
      {required Puppy puppy, required bool isFavorite}) async {
    _baseController.puppyUpdated(puppy.copyWith(isFavorite: isFavorite));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final fetchedPuppy =
          await _repository.favoritePuppy(puppy, isFavorite: isFavorite);
      final updatedPuppy = fetchedPuppy.copyWith(
        breedCharacteristics: puppy.breedCharacteristics,
        displayCharacteristics: puppy.displayCharacteristics,
        displayName: puppy.displayName,
      );
      _baseController.puppyUpdated(updatedPuppy);
    } catch (e) {
      onError.add(e.toString());
      _baseController.puppyUpdated(puppy);
    }
  }

  void clearError() => onError.clear();
}
