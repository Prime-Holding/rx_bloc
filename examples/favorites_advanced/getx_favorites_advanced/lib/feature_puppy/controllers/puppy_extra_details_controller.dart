import 'dart:async';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyExtraDetailsController extends GetxController {
  PuppyExtraDetailsController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final _lastFetchedPuppies = <Puppy>[].obs;
  late Worker _debounceWorker;
  late Worker _clearWorker;

  @override
  Future<void> onInit() async {
    _debounceWorker = debounce<List<Puppy>>(_lastFetchedPuppies, (data) async {
      final filterPuppies =
          data.where((puppy) => !puppy.hasExtraDetails()).toList();
      if (filterPuppies.isEmpty) {
        return;
      }
      try {
        final fetchedPuppies = await _repository.fetchFullEntities(
            filterPuppies.map((element) => element.id).toList());
        data.assignAll(fetchedPuppies);
        _mediatorController
            .updatePuppiesWithExtraDetails(fetchedPuppies);
      } catch (error) {
        print(error.toString());
      }
    }, time: const Duration(milliseconds: 100));
    _clearWorker = ever(_mediatorController.toClearFetchedExtraDetails,
            (_) => _lastFetchedPuppies.clear());
    super.onInit();
  }

  List<Puppy> get lastFetchedPuppies => [..._lastFetchedPuppies];

  Future<void> fetchExtraDetails(Puppy puppy) async {
   if (!_lastFetchedPuppies.any((element) => element.id == puppy.id)) {
      _lastFetchedPuppies.add(puppy);
    }
  }

  @override
  void onClose() {
    _debounceWorker.dispose();
    _clearWorker.dispose();
    super.onClose();
  }
}
