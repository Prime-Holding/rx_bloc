import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get
      ..put(ImagePicker())
      ..put(ConnectivityRepository())
      ..put(PuppiesRepository(
          Get.find<ImagePicker>(),
          Get.find<ConnectivityRepository>(),
        ),
      )
      ..put(NavbarController())
      ..lazyPut(() => MediatorController())
      ..lazyPut(() => FavoritePuppiesController(
          Get.find<PuppiesRepository>(),
          Get.find<MediatorController>()
      ))
      ..lazyPut(() => PuppyListController(
        Get.find<PuppiesRepository>(),
          Get.find<MediatorController>()
    ))
      ..put(PuppyManageController(
          Get.find<PuppiesRepository>(),
          Get.find<MediatorController>()
      ))
      ..lazyPut(() => PuppyExtraDetailsController(
          Get.find<PuppiesRepository>(),
          Get.find<MediatorController>()
      ))
     ;
  }
}
