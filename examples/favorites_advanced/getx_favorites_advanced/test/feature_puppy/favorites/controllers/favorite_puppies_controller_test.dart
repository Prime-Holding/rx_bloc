import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

import '../../../stubs.dart';
import 'favorite_puppies_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late FavoritePuppiesController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    controller = Get.put(FavoritePuppiesController(
        MockPuppiesRepository(), Get.find<MediatorController>()));
  });

  group('FavoritePuppiesController', () {
    //do this temporally
    final controller = Get.put(FavoritePuppiesController(
        Get.find<PuppiesRepository>(), Get.find<MediatorController>()));
    test('return zero if no favorite puppies', () {
      expect(controller.count, 0);
    });
  });
}
