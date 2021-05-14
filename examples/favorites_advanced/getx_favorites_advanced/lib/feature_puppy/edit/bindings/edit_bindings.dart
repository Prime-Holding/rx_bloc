import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class EditBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(PuppyManageController(
          Get.find<PuppiesRepository>(),
            Get.find<CoordinatorController>(),
            puppy: Get.arguments
        ),
    tag: 'Edit'
    );
  }
}
