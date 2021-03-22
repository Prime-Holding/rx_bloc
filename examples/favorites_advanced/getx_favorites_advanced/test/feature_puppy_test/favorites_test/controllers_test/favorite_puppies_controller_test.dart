import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

void main(){
  group('FavoritePuppiesController', (){
    final controller = Get.put(FavoritePuppiesController());
    test('return zero if no favorite puppies', (){
    expect(controller!.count.value, 0);
  });
  test('increment and decrement favorite puppies correctly', (){
    controller!.incrementCount();
    expect(controller.count.value, 1);
    controller.decrementCount();
    expect(controller.count.value, 0);
  });
  test('don\'t decrement if favorite puppies count is zero', (){
    controller!.decrementCount();
    expect(controller.count.value, 0);
  });
  });
}