import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

import '../../stubs.dart';
import 'puppy_manage_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
Future<void> main() async {
  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _coordinatorController;
  late PuppyManageController _controller;

  setUp(() {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _coordinatorController = Get.put(CoordinatorController());
    _controller = Get.put(
        PuppyManageController(_mockRepo, _coordinatorController));
  });

  tearDown(() {
    Get..delete<PuppiesRepository>()
    ..delete<CoordinatorController>()
    ..delete<PuppyManageController>();
  });

  group('PuppyManageController - markAsFavorite - ', () {
    test('successful called function', () async {
      // arrange
      when(_mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => Stub.puppyTestUpdated);
      // action
      await _controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
      // assert
      expect(
          _coordinatorController.puppiesToUpdate, <Puppy>[Stub.puppyTestUpdated]);
      // arrange
      when(_mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => throw Stub.testErr);
      // action
      await _controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
      final puppiesToUpdate = _coordinatorController.puppiesToUpdate;
      // assert
      await expectLater(puppiesToUpdate, <Puppy>[Stub.puppyTest]);
    });
  });
}
