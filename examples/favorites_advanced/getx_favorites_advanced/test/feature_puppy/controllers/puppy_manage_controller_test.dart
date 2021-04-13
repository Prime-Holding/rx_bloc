import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

import '../../stubs.dart';
import 'puppy_manage_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
Future<void> main() async {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyManageController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    controller = Get.put(PuppyManageController(mockRepo, mediatorController));
  });

  group('PuppyManageController - markAsFavorite - ', () {
    test('successful called function', () async {
      // arrange
      when(mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => Stub.puppyTestUpdated);
      // action
      await controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
      // assert
      expect(
          mediatorController.puppiesToUpdate, <Puppy>[Stub.puppyTestUpdated]);
    });
    // test('repo throw exception', () async {
    //   // arrange
    //   when(mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
    //       .thenAnswer((_) async => throw Stub.testErr);
    //   // action
    //   await controller.markAsFavorite(puppy: Stub.puppyTest, isFavorite: true);
    //   final puppiesToUpdate = mediatorController.puppiesToUpdate;
    //   // assert
    //   await expectLater(puppiesToUpdate, <Puppy>[Stub.puppyTest]);
    // });
  });
}
