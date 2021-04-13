import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/controllers/puppy_list_controller.dart';

import '../../../stubs.dart';
import 'puppy_list_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyListController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    when(mockRepo.getPuppies(query: ''))
        .thenAnswer((_) async => Stub.puppies123Test);
    controller = Get.put(PuppyListController(mockRepo, mediatorController));
  });

  group('PuppyListController - ', () {
    test('full list of puppies', () {
      // arrange
      // action
      final puppies = controller.searchedPuppies();
      // assert
      expect(puppies.length, 4);
    });

    // test('empty list when no internet connection', () async {
    //   // arrange
    //   final currentRepo = MockPuppiesRepository();
    //   when(currentRepo.getPuppies(query: ''))
    //       .thenAnswer((_) async => Stub.emptyPuppyList);
    //   // action
    //   final currentController = Get.put(PuppyListController(
    //       currentRepo, mediatorController));
    //   final newPuppies = currentController.searchedPuppies();
    //   // assert
    //   expect(newPuppies.length, 2);
    // });

    test('onReload', () async {
      //arrange
      final initValue = mediatorController.toClearFetchedExtraDetails.value;
      //action
      await controller.onReload();
      final newValue = mediatorController.toClearFetchedExtraDetails.value;
      //assert
      expect(newValue, initValue + 1);
    });

    test('updatePuppiesWithExtraDetails', () async {
      //arrange
      final puppiesToUpdate = Stub.puppiesWithDetails;
      //action
      mediatorController.updatePuppiesWithExtraDetails(puppiesToUpdate);
      final hasExtraDetails = controller
          .searchedPuppies()
          .firstWhere((puppy) => puppy.id == '1')
          .hasExtraDetails();
      //assert
      expect(hasExtraDetails, isTrue);
    });

    test('onPuppyUpdated', () async {
      //arrange
      final puppyToUpdate = Stub.puppyTestUpdated;
      //action
      mediatorController.puppyUpdated(puppyToUpdate);
      final isFavorite = controller
          .searchedPuppies()
          .firstWhere((puppy) => puppy.name == 'Test')
          .isFavorite;
      //assert
      expect(isFavorite, isTrue);
    });
  });
}
