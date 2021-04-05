import 'dart:async';

import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyListController extends GetxController with StateMixin {
  PuppyListController(this._repository, this._baseController);

  final PuppiesRepository _repository;
  final MediatorController _baseController;

  final _puppies = <Puppy>[].obs;

  @override
  Future<void> onInit() async {
    await _initPuppies();
    ever(_baseController.lastFetchedPuppiesLocal, (_) {
      updatePuppiesWithExtraDetails(_baseController.lastFetchedPuppiesLocal);
    });
    ever(_baseController.puppiesToChangeFavoriteStatus, (_) {
      onPuppyUpdated(_baseController.puppiesToChangeFavoriteStatus);
    });
    super.onInit();
  }

  List<Puppy> searchedPuppies() => [..._puppies];

  Future<void> onReload() async {
    await _initPuppies();
    _baseController.clearFetchedExtraDetails();
  }

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.toList().forEach((newPuppyData) {
      final index = _puppies.indexWhere((puppy) => puppy.id == newPuppyData.id);
      _puppies.replaceRange(index, index + 1, [newPuppyData]);
    });
  }

  void onPuppyUpdated(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.forEach((puppy) {
      final currentIndex =
          _puppies.indexWhere((element) => element.id == puppy.id);
      _puppies.replaceRange(currentIndex, currentIndex + 1, [puppy]);
    });
  }

  Future<void> _initPuppies() async {
    change(_puppies, status: RxStatus.loading());
    try {
      final puppies = await _repository.getPuppies(query: '');
      _puppies.assignAll(puppies);
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
      print(e.toString());
    }
  }
}
