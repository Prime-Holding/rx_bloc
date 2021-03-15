import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

main(){
  group("FavoritePuppiesController", (){
  test("return zero if no favorite puppies", (){
    final controller = Get.put(FavoritePuppiesController());
    expect(controller.count.value, 0);
  });
  test("return increment and decrement favorite puppies correctly", (){
    final controller = Get.put(FavoritePuppiesController());
    controller.incrementCount();
    expect(controller.count.value, 1);
    controller.decrementCount();
    expect(controller.count.value, 0);
  });
  test("return don't decrement if favorite puppies count is zero", (){
    final controller = Get.put(FavoritePuppiesController());
    controller.decrementCount();
    expect(controller.count.value, 0);
  });
  });
}