import 'package:favorites_advanced_base/core.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyDetailsController extends GetxController {
  PuppyDetailsController(this._puppy, this._mediatorController);
  final MediatorController _mediatorController;
  final Puppy _puppy;
  late Rx<Puppy>? puppy;

  @override
  void onInit() {
    puppy = _puppy.obs;
    ever(_mediatorController.puppiesToUpdate, (_) {
      try{
        final updatedPuppy = _mediatorController.puppiesToUpdate
            .firstWhere((element) => element.id == _puppy.id);
        print('Gender of updated puppy is ${updatedPuppy.genderAsString}');
        puppy!(updatedPuppy);
      }catch (e){
        print(e.toString());
      }
    });
    super.onInit();
  }
}
