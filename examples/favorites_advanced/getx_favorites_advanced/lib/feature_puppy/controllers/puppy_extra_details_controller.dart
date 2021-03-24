import 'dart:async';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/base/controllers/base_controller.dart';

class PuppyExtraDetailsController extends GetxController {
  PuppyExtraDetailsController(PuppiesRepository repository,
      BaseController controller){
    _repository = repository;
    _baseController = controller;
  }
  late PuppiesRepository _repository;
  late BaseController _baseController;
  final lastFetchedPuppies = <Puppy>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   ever(
  //       lastFetchedPuppies,
  //       (lastFetchedPuppies) => Get.find<PuppyListController>()
  //           .updatePuppiesWithExtraDetails(lastFetchedPuppies));
  // }

  Future<void> fetchExtraDetails(Puppy puppy) async {
    if(!lastFetchedPuppies.any((element) => element.id == puppy.id)) {
      lastFetchedPuppies.add(puppy);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    final filterPuppies = lastFetchedPuppies
        .where((puppy) => !puppy.hasExtraDetails()).toList();
    if (filterPuppies.isEmpty) {
      return;
    }
    lastFetchedPuppies.assignAll(await _repository.fetchFullEntities(
        filterPuppies.map((element) => element.id).toList()));
    _baseController
        .updatePuppiesWithExtraDetails(lastFetchedPuppies);
  }
}
