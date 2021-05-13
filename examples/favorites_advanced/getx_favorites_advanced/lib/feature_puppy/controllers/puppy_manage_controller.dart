import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';

class PuppyManageController extends GetxController with StateMixin {
  PuppyManageController(this._repository, this._coordinatorController);

  final PuppiesRepository _repository;
  final CoordinatorController _coordinatorController;

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
