import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

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
    when(mockRepo.getFavoritePuppies())
        .thenAnswer((_) async => Stub.emptyPuppyList);
    controller =
        Get.put(FavoritePuppiesController(mockRepo, mediatorController));
  });

  group('FavoritePuppiesController - ', () {
    test('initialization', () {
    //arrange
    //action
    final count = controller.count;
    //assert
    expect(count,0);
    });
    test('updateFavoritePuppies', () {
    //arrange
      final updatedPuppies = Stub.puppiesTestUpdated;
    //action
    mediatorController.puppiesToUpdate(updatedPuppies);
    final count = controller.count;
    final puppy = controller.favoritePuppiesList.first;
    //assert
    expect(count, 1);
    expect(puppy, Stub.puppyTestUpdated);
    });
  });
}
