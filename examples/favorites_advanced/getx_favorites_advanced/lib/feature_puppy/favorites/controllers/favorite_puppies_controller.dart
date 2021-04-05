import 'package:get/get.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class FavoritePuppiesController extends GetxController with StateMixin {
  FavoritePuppiesController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final _favoritePuppies = <Puppy>[].obs;

  int get count => _favoritePuppies.length;

  @override
  void onInit() {
    _initFavoritePuppies();
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
      //  TODO something here when build FavoritePage - set RxState to empty
    }
  }

  void updateFavoritePuppies(List<Puppy> puppiesToUpdate) {
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
  void onReady() {
    ever(
        _mediatorController.puppiesToChangeFavoriteStatus,
            (_) => updateFavoritePuppies(
            _mediatorController.puppiesToChangeFavoriteStatus));
    super.onReady();
  }
}
