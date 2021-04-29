import 'package:favorites_advanced_base/core.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyDetailsController extends GetxController {
  PuppyDetailsController(this._puppy, this._mediatorController);
  final MediatorController _mediatorController;
  final Puppy _puppy;
  Rx<Puppy>? puppy;
  var isFavorite = false.obs;

  @override
  void onInit() {
    puppy= _puppy.obs;
    isFavorite(puppy?.value.isFavorite);
    ever(
        _mediatorController.puppiesToUpdate,
        (_) => _mediatorController.puppiesToUpdate.forEach((element) {
              if (element.id == _puppy.id) {
                puppy!(element);
              }
            }));
    super.onInit();
  }


}
