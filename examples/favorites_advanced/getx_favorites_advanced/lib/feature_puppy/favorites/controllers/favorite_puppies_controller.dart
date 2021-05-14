import 'dart:async';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';

class FavoritePuppiesController extends GetxController
    with StateMixin<List<Puppy>> {
  FavoritePuppiesController(this._repository, this._coordinatorController);

  final PuppiesRepository _repository;
  final CoordinatorController _coordinatorController;

  final RxList<Puppy> favoritePuppies = <Puppy>[].obs;
  late Worker updatingWorker;

  int get count => favoritePuppies.length;

  List<Puppy> get favoritePuppiesList => [...favoritePuppies];

  @override
  void onInit() {
    _initFavoritePuppies();
    updatingWorker = ever(_coordinatorController.puppiesToUpdate,
        (_) => _updateFavoritePuppies(_coordinatorController.puppiesToUpdate));
    super.onInit();
  }

  Future<void> _initFavoritePuppies() async {
    try {
      change(<Puppy>[], status: RxStatus.loading());
      final puppies = await _repository.getFavoritePuppies();
      favoritePuppies.assignAll(puppies);
      change(puppies, status: RxStatus.success());
    } catch (e) {
      print('Fetching favorite puppies failed: ${e.toString()}');
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
        } else if(currentIndex >=0){
          if( !puppy.isFavorite){
            favoritePuppies.removeAt(currentIndex);
          }else {
            favoritePuppies.replaceRange(currentIndex, currentIndex+1, [puppy]);
          }
        }
      },
    );
    change(favoritePuppies.call(), status: RxStatus.success());
  }

  Future<void> onReload() async {
    await _initFavoritePuppies();
    _coordinatorController.clearFetchedExtraDetails();
  }

  @override
  void onClose() {
    updatingWorker.dispose();
    super.onClose();
  }
}
