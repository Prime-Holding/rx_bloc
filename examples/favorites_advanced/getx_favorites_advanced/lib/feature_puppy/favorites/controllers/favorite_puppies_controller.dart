import 'package:get/get.dart';
import 'package:favorites_advanced_base/core.dart';

class FavoritePuppiesController extends GetxController with StateMixin {
  FavoritePuppiesController(this._repository);

  final _favoritePuppies = <Puppy>[].obs;
  final PuppiesRepository _repository;

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
}
