import 'package:favorites_advanced_base/core.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyEditingController extends GetxController{
  PuppyEditingController(this._mediatorController, this._puppy);
  MediatorController _mediatorController;
  Puppy _puppy;

  final isSaveEnabled = false.obs;
  final isLoading = false.obs;
  final asset = ''.obs;
  @override
  void onInit() {
    _initFields();
    super.onInit();
  }

  void _initFields() {
    asset(_puppy.asset);
  }
}