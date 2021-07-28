import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/controllers/puppy_details_controller.dart';

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
        PuppyDetailsController(
            Get.arguments,
            Get.find<CoordinatorController>()
        ));
  }
}
