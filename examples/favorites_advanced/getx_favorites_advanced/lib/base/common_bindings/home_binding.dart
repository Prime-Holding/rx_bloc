import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NavbarController());
    // ignore: cascade_invocations
    Get.put(FavoritePuppiesController());
    // ignore: cascade_invocations
    Get.put(PuppiesRepository(ImagePicker()));
    // ignore: cascade_invocations
    Get.put(PuppyListController());
    // ignore: cascade_invocations
    Get.put(PuppyExtraDetailsController());
  }
}
