import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class FavoritePuppiesController extends GetxController with StateMixin {
  FavoritePuppiesController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final RxList<Puppy> _favoritePuppies = <Puppy>[].obs;
  late Worker updatingWorker;

  int get count => _favoritePuppies.length;

  List<Puppy> get favoritePuppiesList => [..._favoritePuppies];

  Stream<List<Puppy>> streamPuppiesList() =>
      _favoritePuppies.stream
          .map((event) => event ?? <Puppy>[])
          .whereType<List<Puppy>>().asBroadcastStream();

  @override
  void onInit() {
    _initFavoritePuppies();
    updatingWorker = ever(_mediatorController.puppiesToUpdate,
        (_) => _updateFavoritePuppies(_mediatorController.puppiesToUpdate));
    super.onInit();
  }

  Future<void> _initFavoritePuppies() async {
    try {
      change(_favoritePuppies, status: RxStatus.loading());
      final puppies = await _repository.getFavoritePuppies();
      _favoritePuppies.assignAll(puppies);
      change(_favoritePuppies, status: RxStatus.success());
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateFavoritePuppies(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.forEach(
      (puppy) {
        final currentIndex =
            _favoritePuppies.indexWhere((element) => element.id == puppy.id);
        if (currentIndex < 0) {
          _favoritePuppies.add(puppy);
        } else {
          _favoritePuppies.removeAt(currentIndex);
        }
      },
    );
  }

  @override
  void onClose() {
    updatingWorker.dispose();
    super.onClose();
  }
}
