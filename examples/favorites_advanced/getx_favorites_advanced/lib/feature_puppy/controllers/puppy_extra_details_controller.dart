import 'dart:async';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/base_controller.dart';

class PuppyExtraDetailsController extends GetxController {
  PuppyExtraDetailsController(this._repository, this._baseController);

  final PuppiesRepository _repository;
  final BaseController _baseController;
  final lastFetchedPuppies = <Puppy>[].obs;
  late Worker debounceWorker;

  @override
  Future<void> onInit() async {
    debounceWorker = debounce<List<Puppy>>(lastFetchedPuppies, (data) async {
      final filterPuppies =
          data.where((puppy) => !puppy.hasExtraDetails()).toList();
      if (filterPuppies.isEmpty) {
        return;
      }
      try{
        final fetchedPuppies = await _repository.fetchFullEntities(
            filterPuppies.map((element) => element.id).toList());
        data.assignAll(fetchedPuppies);
        _baseController.updatePuppiesWithExtraDetails(data.obs);
      }catch (error){
        print(error.toString());
      }

    }, time: const Duration(milliseconds: 100));
    super.onInit();
  }

  Future<void> fetchExtraDetails(Puppy puppy) async {
    if (!lastFetchedPuppies.any((element) => element.id == puppy.id)) {
      lastFetchedPuppies.add(puppy);
    }
  }

  void onReload(){
    lastFetchedPuppies.clear();
  }

  @override
  void onClose() {
    debounceWorker.dispose();
    super.onClose();
  }
}
