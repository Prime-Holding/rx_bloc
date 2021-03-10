import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class FavoritePuppiesController extends GetxController{
  final count = 0.obs;

  void incrementCount(){
    count.value++;
  }

  void decrementCount(){
    if(count.value>=1){
      count.value--;
    }
  }

}