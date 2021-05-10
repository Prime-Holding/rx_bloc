import 'dart:async';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class FavoritePuppiesController extends GetxController
    with StateMixin<List<Puppy>> {
  FavoritePuppiesController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final RxList<Puppy> favoritePuppies = <Puppy>[].obs;
  late Worker updatingWorker;

  int get count => favoritePuppies.length;

  List<Puppy> get favoritePuppiesList => [...favoritePuppies];

  @override
  void onInit() {
    _initFavoritePuppies();
    updatingWorker = ever(_mediatorController.puppiesToUpdate,
        (_) => _updateFavoritePuppies(_mediatorController.puppiesToUpdate));
    super.onInit();
  }

  Future<void> _initFavoritePuppies() async {
    try {
      change(<Puppy>[], status: RxStatus.loading());
      final puppies = await _repository.getFavoritePuppies();
      favoritePuppies.assignAll(puppies);
      change(puppies, status: RxStatus.success());
    } catch (e) {
      print(e.toString());
      change(<Puppy>[], status: RxStatus.error());
    }
  }

  void _updateFavoritePuppies(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.forEach(
      (puppy) {
        final currentIndex =
            favoritePuppies.indexWhere((element) => element.id == puppy.id);
        if (currentIndex < 0 && puppy.isFavorite) {
          favoritePuppies.add(puppy);
        } else if(currentIndex >=0 && !puppy.isFavorite){
          favoritePuppies.removeAt(currentIndex);
        }
      },
    );
    change(favoritePuppies.call(), status: RxStatus.success());
  }

  Future<void> onReload() async {
    await _initFavoritePuppies();
    _mediatorController.clearFetchedExtraDetails();
  }

  @override
  void onClose() {
    updatingWorker.dispose();
    super.onClose();
  }
}
