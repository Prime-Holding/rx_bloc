import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyManageController extends GetxController with StateMixin {
  PuppyManageController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final puppyToUpdate = <Puppy>[].obs;

  Future<void> markAsFavorite(
      {required Puppy puppy, required bool isFavorite}) async {
    _mediatorController.puppyUpdated(puppy.copyWith(isFavorite: isFavorite));
    try {
      await _repository.favoritePuppy(puppy, isFavorite: isFavorite);
    } catch (e) {
      await Get.showSnackbar(GetBar(
        message: e.toString().substring(10),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        duration: const Duration(seconds: 2),
      ));
      _mediatorController.puppyUpdated(puppy);
    }
  }
}
