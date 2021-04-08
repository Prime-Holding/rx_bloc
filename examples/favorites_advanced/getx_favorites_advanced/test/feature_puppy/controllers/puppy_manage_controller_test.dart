import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

import '../../stubs.dart';
import 'puppy_manage_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyManageController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    controller = Get.put(PuppyManageController(mockRepo, mediatorController));
  });

  group('PuppyManageController.markAsFavorite', () {
    test('successful called function', () {
      final puppy = Stub.puppyTest;
      when(mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => Stub.puppyTestUpdated);
      verifyNever(controller.markAsFavorite(puppy: puppy, isFavorite: true));
      controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
      verify(controller.markAsFavorite(puppy: puppy, isFavorite: true))
          .called(1);
      final isFavorite = mediatorController.puppiesToUpdate.first.isFavorite;
      assert(isFavorite, 'should be true');
    });
    test('repo throw exception', () {
      final puppy = Stub.puppyTest;
      when(mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => throw Stub.testErr);
          controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
      verify(controller.markAsFavorite(puppy: puppy, isFavorite: true))
          .called(1);
      // final isFavorite = mediatorController.puppiesToUpdate.first.isFavorite;
      // assert(!isFavorite, 'should be false');
    });
  });
}
