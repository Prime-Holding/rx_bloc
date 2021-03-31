import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/network_controller.dart';

class NetworkBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkController());
  }

}