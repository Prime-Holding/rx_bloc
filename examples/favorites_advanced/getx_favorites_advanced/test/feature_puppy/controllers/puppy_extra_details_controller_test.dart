import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';

import '../../stubs.dart';
import 'puppy_extra_details_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _mediatorController;
  late PuppyExtraDetailsController _controller;

  setUp(() {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _mediatorController = Get.put(CoordinatorController());
    _controller =
        Get.put(PuppyExtraDetailsController(_mockRepo, _mediatorController));
  });

  tearDown(() {
    Get..delete<MockPuppiesRepository>()
      ..delete<CoordinatorController>()
      ..delete<PuppyExtraDetailsController>();
  });

  group('PuppyExtraDetailsController - ', () {
    test('initialization', () async {
      //arrange
      //action
      await _controller.onInit();
      //assert
      final puppiesCount = _controller.lastFetchedPuppies.length;
      expect(puppiesCount, 0);
    });

    test('fetchExtraDetails', () async {
      //arrange
      when(_mockRepo.fetchFullEntities(['1', '2'])).thenAnswer(
          (_) async => Future.value(Stub.puppies1And2WithExtraDetails));
      //action
      await _controller.fetchExtraDetails(Stub.puppy1);
      await _controller.fetchExtraDetails(Stub.puppy2);
      await Stub.delayed(Stub.puppy3, milliseconds: 120);
      //assert
      final updatedPuppies = _controller.lastFetchedPuppies.length;
      expect(updatedPuppies, 2);
      verifyNever(_mockRepo.fetchFullEntities([Stub.puppy1.id]));
      verifyNever(_mockRepo.fetchFullEntities([Stub.puppy2.id]));
      verifyNever(_mockRepo.fetchFullEntities(Stub.puppies123.ids));
      verify(_mockRepo.fetchFullEntities(Stub.puppies12.ids)).called(1);
    });

    test('does not fetch details when Repository throws Exception', () async {
      //arrange
      when(_mockRepo.fetchFullEntities(['1', '2']))
          .thenAnswer((_) async => throw Stub.testErr);
      //action
      await _controller.fetchExtraDetails(Stub.puppy1);
      await _controller.fetchExtraDetails(Stub.puppy2);
      await Future.delayed(const Duration(milliseconds: 110));
      //assert
      final hasPuppyExtraDetail =
          _controller.lastFetchedPuppies.first.hasExtraDetails();
      expect(hasPuppyExtraDetail, isFalse);
    });

    test('clearExtraFetchedDetails', () async {
      //arrange
      when(_mockRepo.fetchFullEntities(['1', '2']))
          .thenAnswer((_) async => Stub.puppies1And2WithExtraDetails);
      //action
      await _controller.fetchExtraDetails(Stub.puppy1);
      await _controller.fetchExtraDetails(Stub.puppy2);
      await Future.delayed(const Duration(milliseconds: 110));
      _mediatorController.clearFetchedExtraDetails();
      //assert
      final updatedPuppies = _controller.lastFetchedPuppies.length;
      expect(updatedPuppies, 0);
    });
  });
}
