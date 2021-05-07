import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/controllers/puppy_editing_controller.dart';

class EditBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        PuppyEditingController(
            Get.find<MediatorController>(),
            Get.arguments
        ));
  }
}
