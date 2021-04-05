import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyManageController extends GetxController with StateMixin {
  PuppyManageController(this._repository, this._baseController);

  final PuppiesRepository _repository;
  final MediatorController _baseController;

  final puppyToUpdate = <Puppy>[].obs;

  Future<void> markAsFavorite(
      {required Puppy puppy, required bool isFavorite}) async {
    _baseController.puppyUpdated(puppy.copyWith(isFavorite: isFavorite));
    try {
      await _repository.favoritePuppy(puppy, isFavorite: isFavorite);
    } catch (e) {
      print('Exception in ManageController');
      change(puppyToUpdate, status: RxStatus.error(e.toString()));
      await Get.showSnackbar(GetBar(
        message: e.toString(),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        duration: const Duration(seconds: 2),
      ));
      _baseController.puppyUpdated(puppy);
    }
  }

  void clearError() {
    change(puppyToUpdate, status: RxStatus.success());
  }
}
