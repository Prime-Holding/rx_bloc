import 'package:get/get.dart';
import 'package:favorites_advanced_base/core.dart';

class FavoritePuppiesController extends GetxController {
  FavoritePuppiesController(PuppiesRepository repository) {
    _repository = repository;
    _initPuppies();
  }
  final _favoritePuppies = <Puppy>[].obs;
  late PuppiesRepository _repository;

  int get count => _favoritePuppies.length;

  Future<void> _initPuppies() async {
    try {
      final puppies = await _repository.getFavoritePuppies();
      _favoritePuppies.assignAll(puppies);
    } catch (e) {
      print(e.toString());
    }
  }

  void updateFavoritePuppies(List<Puppy> puppiesToUpdate) {
    final copiedPuppies = <Puppy>[..._favoritePuppies];
    puppiesToUpdate.where((puppy) => puppy.isFavorite).forEach((puppy) {
      final currentIndex =
          copiedPuppies.indexWhere((element) => element.id == puppy.id);
      if (currentIndex < 0) {
        copiedPuppies.add(puppy);
      } else {
        copiedPuppies.replaceRange(currentIndex, currentIndex + 1, [puppy]);
      }
    });
    puppiesToUpdate.where((puppy) => !puppy.isFavorite).forEach((puppy) {
      final currentIndex =
          copiedPuppies.indexWhere((element) => element.id == puppy.id);
      if (currentIndex >= 0) {
        copiedPuppies.removeAt(currentIndex);
      }
    });
    _favoritePuppies.assignAll(copiedPuppies);
  }
}
