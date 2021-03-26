import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/base_controller.dart';

class PuppyManageController extends GetxController {
  PuppyManageController(this._repository, this._baseController);

  final PuppiesRepository _repository;
  final BaseController _baseController;
  final puppyToUpdate = <Puppy>[].obs;
  final onError = <String>[].obs;

  Future<void> favoritePuppy(
      {required Puppy puppy, required bool isFavorite}) async {
    _baseController.puppyUpdated(puppy.copyWith(isFavorite: isFavorite));
    try {
      await _repository.favoritePuppy(puppy, isFavorite: isFavorite);
    } catch (e) {
      onError.add(e.toString());
      _baseController.puppyUpdated(puppy);
    }
  }

  void clearError() => onError.clear();
}
