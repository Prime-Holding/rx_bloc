import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';

import '../../stubs.dart';
import 'puppy_extra_details_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyExtraDetailsController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    controller =
        Get.put(PuppyExtraDetailsController(mockRepo, mediatorController));
  });

  tearDown(() {
    Get.delete<MockPuppiesRepository>();
  });

  group('PuppyExtraDetailsController - ', () {
    test('initialization', () {
      //arrange
      final puppiesCount = controller.lastFetchedPuppies.length;
      //action
      //assert
      expect(puppiesCount, 0);
    });
    test('fetchExtraDetails', () async {
      //arrange
      when(mockRepo.fetchFullEntities(['1', '2'])).thenAnswer(
          (_) async => Future.value(Stub.puppies1And2WithExtraDetails));
      //action
      await controller.fetchExtraDetails(Stub.puppy1);
      await controller.fetchExtraDetails(Stub.puppy2);
      await Future.delayed(const Duration(milliseconds: 110));
      //assert
      final updatedPuppies = controller.lastFetchedPuppies.length;
      expect(updatedPuppies, 2);
    });
    test('clearExtraFetchedDetails', () async {
      //arrange
      when(mockRepo.fetchFullEntities(['1', '2']))
          .thenAnswer((_) async => Stub.puppies1And2WithExtraDetails);
      //action
      await controller.fetchExtraDetails(Stub.puppy1);
      await controller.fetchExtraDetails(Stub.puppy2);
      await Future.delayed(const Duration(milliseconds: 110));
      mediatorController.clearFetchedExtraDetails();
      //assert
      final updatedPuppies = controller.lastFetchedPuppies.length;
      expect(updatedPuppies, 0);
    });
  });
}
