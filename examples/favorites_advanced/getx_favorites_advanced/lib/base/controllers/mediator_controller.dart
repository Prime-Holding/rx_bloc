import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

class MediatorController extends GetxController {
  MediatorController();

  final lastFetchedPuppiesLocal = <Puppy>[].obs;
  final puppiesToChangeFavoriteStatus = <Puppy>[].obs;
  final toClearFetchedExtraDetails = 0.obs;

  void updatePuppiesWithExtraDetails(RxList<Puppy> lastFetchedPuppies) =>
      lastFetchedPuppiesLocal.assignAll(lastFetchedPuppies);

  void puppiesUpdated(List<Puppy> puppiesToUpdate) =>
      puppiesToChangeFavoriteStatus.assignAll(puppiesToUpdate);

  void puppyUpdated(Puppy puppy) => puppiesUpdated([puppy]);

  void clearFetchedExtraDetails() => toClearFetchedExtraDetails.value +=1;
}
