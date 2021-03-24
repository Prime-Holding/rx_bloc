import 'package:get/get.dart';
import 'package:favorites_advanced_base/core.dart';

class FavoritePuppiesController extends GetxController {
  FavoritePuppiesController(PuppiesRepository repository){
    _repository = repository;
  }
  //will use it soon
  late PuppiesRepository _repository;
  final count = 0.obs;

  void incrementCount() => count.value++;

  void decrementCount() {
    if (count.value >= 1) {
      count.value--;
    }
  }

}
