import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

void main(){
  group('FavoritePuppiesController', (){
    //do this temporally
    final controller = Get.put(
        FavoritePuppiesController(Get.find<PuppiesRepository>()));
    test('return zero if no favorite puppies', (){
    expect(controller.count, 0);
  });

  });
}