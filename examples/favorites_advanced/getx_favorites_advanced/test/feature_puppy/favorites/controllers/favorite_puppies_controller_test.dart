import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

import '../../../stubs.dart';
import 'favorite_puppies_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _mediatorController;
  late FavoritePuppiesController _controller;

  setUp(() {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _mediatorController = Get.put(CoordinatorController());
    when(_mockRepo.getFavoritePuppies())
        .thenAnswer((_) async => Stub.emptyPuppyList);
    _controller =
        Get.put(FavoritePuppiesController(_mockRepo, _mediatorController));
  });

  tearDown(() {
    Get..delete<MockPuppiesRepository>()
      ..delete<CoordinatorController>()
      ..delete<FavoritePuppiesController>();
  });

  group('FavoritePuppiesController - ', () {
    test('successful initialization with empty list', () async {
      //assert
      expect(_controller.count, 0);
    });

    test('successful initialization with full list', () async {
      //arrange
      reset(_mockRepo);
      when(_mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.puppiesTestUpdated);
      // action
      await _controller.onReload();
      final puppiesCount = _controller.favoritePuppiesList.length;
      // assert
      expect(puppiesCount, 1);
    });

    test('initialization when Repository throws', () async {
      //assert
      expect(_controller.count, 0);
      //arrange
      reset(_mockRepo);
      when(_mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => throw Stub.testErr);
      //action
      await _controller.onReload();
      //assert
      expect(_controller.status.isError, true);
    });

    test('updateFavoritePuppies on Reload', () async {
      //arrange
      reset(_mockRepo);
      when(_mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.puppiesTestUpdated);
      await _controller.onReload();
      expect(_controller.count, 1);
      final puppy = _controller.favoritePuppiesList.first;
      expect(puppy.isFavorite, isTrue);
      expect(puppy, Stub.puppyTestUpdated);
    });

    test('updateFavoritePuppies - favorite puppy', () async {
      final updatedPuppy = Stub.puppyTestUpdated;
      //action
      await _controller.onReload();
      _mediatorController.puppyUpdated(updatedPuppy);
      final count = _controller.count;
      final puppy = _controller.favoritePuppiesList.first;
      //assert
      expect(count, 1);
      expect(puppy, Stub.puppyTestUpdated);
    });

    test('updateFavoritePuppies - unfavorite puppy', () async {
      //arrange
      reset(_mockRepo);
      when(_mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.puppiesTestUpdated);
      final unfavoritePuppy = Stub.puppyTest;
      //action
      await _controller.onReload();
      _mediatorController.puppyUpdated(unfavoritePuppy);
      final count = _controller.count;
      //assert
      expect(count, 0);
    });

    test('updateFavoritePuppies - edited favorite puppy', () async {
      //arrange
      reset(_mockRepo);
      when(_mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.puppiesTestUpdated);
      final editedPuppy = Stub.puppyTestUpdated.copyWith(name: 'NewName');
      //action
      await _controller.onReload();
      _mediatorController.puppyUpdated(editedPuppy);
      final puppy = _controller.favoritePuppiesList.first;
      //assert
      expect(puppy.name, 'NewName');
      expect(puppy.isFavorite, isTrue);

    });
  });
}
