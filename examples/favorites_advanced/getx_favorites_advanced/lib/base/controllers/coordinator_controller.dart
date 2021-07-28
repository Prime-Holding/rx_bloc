import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

class CoordinatorController extends GetxController {
  var lastFetchedPuppies = <Puppy>[].obs;
  final puppiesToUpdate = <Puppy>[].obs;
  final toClearFetchedExtraDetails = 0.obs;

  void updatePuppiesWithExtraDetails(List<Puppy> newFetchedPuppies) =>
      lastFetchedPuppies.assignAll(newFetchedPuppies);

  void puppiesUpdated(List<Puppy> updatedPuppies) =>
      puppiesToUpdate.assignAll(updatedPuppies);

  void puppyUpdated(Puppy puppy) => puppiesUpdated([puppy]);

  void clearFetchedExtraDetails() => toClearFetchedExtraDetails.value += 1;
}
