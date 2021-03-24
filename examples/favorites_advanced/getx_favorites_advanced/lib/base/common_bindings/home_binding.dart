import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/base_controller.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get
      ..put(ImagePicker())
      ..put(ConnectivityRepository())
      ..put(
        PuppiesRepository(
          Get.find<ImagePicker>(),
          Get.find<ConnectivityRepository>(),
        ),
      )
      ..put(NavbarController())
      ..put(FavoritePuppiesController(
          Get.find<PuppiesRepository>()
      ))
      ..put(PuppyListController(
          Get.find<PuppiesRepository>()
      ))
      ..lazyPut(() => BaseController(
          Get.find<PuppyListController>(),
          Get.find<FavoritePuppiesController>()
      ))
      ..put(PuppyManageController(
          Get.find<PuppiesRepository>(),
          Get.find<BaseController>()
      ))
      ..put(PuppyExtraDetailsController(
          Get.find<PuppiesRepository>(),
          Get.find<BaseController>()
      ))
     ;
  }
}
