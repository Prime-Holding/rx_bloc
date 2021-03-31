import 'package:favorites_advanced_base/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main(){
  group('PuppyListController - ', (){
    final controller = Get.put(PuppyListController);
    group('init puppiesList', (){
      test('when no internet connection', (){

      });
    });
  });
}