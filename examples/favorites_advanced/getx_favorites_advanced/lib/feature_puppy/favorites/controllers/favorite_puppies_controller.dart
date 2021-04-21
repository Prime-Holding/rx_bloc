import 'dart:async';
// import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/stubs.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class FavoritePuppiesController extends GetxController with StateMixin<RxList<Puppy>> {
  FavoritePuppiesController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final streamContr = StreamController<List<Puppy>>.broadcast();

  final RxList<Puppy> _favoritePuppies = <Puppy>[].obs;
  late Worker updatingWorker;

  int get count => _favoritePuppies.length;

  List<Puppy> get favoritePuppiesList => [..._favoritePuppies];
  RxList<Puppy> get favoritePuppiesRxList => _favoritePuppies;

  Stream<List<Puppy>> streamPuppiesList() =>
      // Stream.fromIterable([Stub.puppies123]).asBroadcastStream();
      // _favoritePuppies.stream
      //     .asyncMap((event) => event ?? <Puppy>[])
      //     .whereType<List<Puppy>>().share();
  streamContr.stream;

  @override
  void onInit() {
    _initFavoritePuppies();
    updatingWorker = ever(_mediatorController.puppiesToUpdate,
        (_) => _updateFavoritePuppies(_mediatorController.puppiesToUpdate));
    ever(_favoritePuppies, (data) => streamContr.add(favoritePuppiesList));
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
      change(null, status: RxStatus.error());
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
    streamContr.close();
    super.onClose();
  }
}
