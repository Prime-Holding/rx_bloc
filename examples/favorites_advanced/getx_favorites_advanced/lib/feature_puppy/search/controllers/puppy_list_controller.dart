import 'dart:async';

import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyListController extends GetxController
    with StateMixin<RxList<Puppy>> {
  PuppyListController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final _puppies = <Puppy>[].obs;
  final filteredBy = ''.obs;
  late Worker updateFetchedDetailsWorker;
  late Worker updateFavoriteStatusWorker;

  @override
  Future<void> onInit() async {
    change(_puppies, status: RxStatus.loading());
    await _loadPuppies('');
    updateFetchedDetailsWorker =
        ever(_mediatorController.lastFetchedPuppies, (_) {
      updatePuppiesWith(_mediatorController.lastFetchedPuppies);
    });
    updateFavoriteStatusWorker = ever(_mediatorController.puppiesToUpdate, (_) {
      updatePuppiesWith(_mediatorController.puppiesToUpdate.toList());
    });
    super.onInit();
  }

  List<Puppy> searchedPuppies() => [..._puppies];

  Future<void> onRefresh() async {
    await _loadPuppies('');
    _mediatorController.clearFetchedExtraDetails();
  }

  Future<void> onReload() async {
    change(_puppies, status: RxStatus.loading());
   await onRefresh();
  }

  void updatePuppiesWith(List<Puppy> puppiesToUpdate) {
    // _puppies.mergeWith(puppiesToUpdate);
    puppiesToUpdate.forEach((puppy) {
      final index = _puppies.indexWhere((element) => element.id == puppy.id);
      if (index >= 0 && index < _puppies.length) {
        _puppies.replaceRange(index, index + 1, [puppy]);
      } else {
        _puppies.add(puppy);
      }
    });
  }

  Future<void> _loadPuppies(String query) async {
    try {
      final puppies = await _repository.getPuppies(query: query);
      _puppies.assignAll(puppies);
      await Future.delayed(const Duration(milliseconds: 150));
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
      print(e.toString());
    }
  }

  void filterPuppies(String keyString){
    _loadPuppies(keyString);
    filteredBy(keyString);
    _mediatorController.clearFetchedExtraDetails();
  }

  @override
  void onClose() {
    updateFetchedDetailsWorker.dispose();
    updateFavoriteStatusWorker.dispose();
    super.onClose();
  }
}
