import 'dart:async';

import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';

class PuppyListController extends GetxController
    with StateMixin<RxList<Puppy>> {
  PuppyListController(this._repository, this._coordinatorController);

  final PuppiesRepository _repository;
  final CoordinatorController _coordinatorController;

  final _puppies = <Puppy>[].obs;
  final filteredBy = ''.obs;
  late Worker updateFetchedDetailsWorker;
  late Worker updateFavoriteStatusWorker;
  late Worker searchMatchingChecker;
  late Worker filteringDebounce;

  @override
  Future<void> onInit() async {
    change(_puppies, status: RxStatus.loading());
    await _loadPuppies('');
    updateFetchedDetailsWorker =
        ever(_coordinatorController.lastFetchedPuppies, (_) {
      _updatePuppiesWith(_coordinatorController.lastFetchedPuppies);
    });
    updateFavoriteStatusWorker = ever(_coordinatorController.puppiesToUpdate, (_) {
      _updatePuppiesWith(_coordinatorController.puppiesToUpdate);
    });
    searchMatchingChecker = ever(
        _puppies,
        (_) => _puppies.isEmpty
            ? change(_puppies, status: RxStatus.empty())
            : change(_puppies, status: RxStatus.success()));
    filteringDebounce = debounce<String>(
        filteredBy, (filterString) => filterPuppies(filterString),
        time: const Duration(milliseconds: 500));
    super.onInit();
  }

  List<Puppy> searchedPuppies() {
    if (_puppies.isEmpty) {
      change(_puppies, status: RxStatus.empty());
    }
    return [..._puppies];
  }

  void setFilter(String keyString) {
    filteredBy(keyString);
  }

  Future<void> onRefresh() async {
    _coordinatorController.clearFetchedExtraDetails();
    await _loadPuppies(filteredBy.value);
  }

  Future<void> onReload() async {
    change(_puppies, status: RxStatus.loading());
    await onRefresh();
  }

  void _updatePuppiesWith(List<Puppy> puppiesToUpdate) {
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
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      _puppies.clear();
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
    }
  }

  Future<void> filterPuppies(String keyString) async {
    change(_puppies, status: RxStatus.loading());
    await _loadPuppies(keyString);
    filteredBy(keyString);
    _coordinatorController.clearFetchedExtraDetails();
  }

  @override
  void onClose() {
    updateFetchedDetailsWorker.dispose();
    updateFavoriteStatusWorker.dispose();
    searchMatchingChecker.dispose();
    filteringDebounce.dispose();
    super.onClose();
  }
}
