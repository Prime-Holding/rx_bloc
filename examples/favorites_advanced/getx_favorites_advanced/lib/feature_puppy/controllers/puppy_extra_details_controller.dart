import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

class PuppyExtraDetailsController extends GetxController {
  final _repository = Get.find<PuppiesRepository>();
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
    // debugPrint('in function body');
    if(!lastFetchedPuppies.any((element) => element.id == puppy.id)) {
      lastFetchedPuppies.add(puppy);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    // debugPrint(
    //     'first print *** lastFetchedPuppies count = ${lastFetchedPuppies.length}');
    // lastFetchedPuppies.forEach((element) {
    //   debugPrint('after first print ${element.name}');});
    final filterPuppies =
        lastFetchedPuppies.where((puppy) => !puppy.hasExtraDetails()).toList();
    // debugPrint('filteredPuppies count = ${filterPuppies.length}');
    if (filterPuppies.isEmpty) {
      return;
    }
    lastFetchedPuppies.assignAll(await _repository.fetchFullEntities(
        filterPuppies.map((element) => element.id).toList()));
    // lastFetchedPuppies.forEach((element) {
    //   debugPrint(element.name);});
    // debugPrint(
    //     'second print *** lastFetchedPuppies count = ${lastFetchedPuppies.length}');
    Get.find<PuppyListController>()
        .updatePuppiesWithExtraDetails(lastFetchedPuppies);
  }
}
