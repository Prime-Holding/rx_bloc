import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NavbarController());
    Get.put(FavoritePuppiesController());
  }
}
