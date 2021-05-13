import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/controllers/puppy_list_controller.dart';

import '../../../stubs.dart';
import 'puppy_list_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _coordinatorController;
  late PuppyListController _controller;

  setUp(() async {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _coordinatorController = Get.put(CoordinatorController());
    when(_mockRepo.getPuppies(query: ''))
        .thenAnswer((_) async => Stub.puppies123Test);
    _controller = Get.put(PuppyListController(_mockRepo, _coordinatorController));
  });

  tearDown(() {
    Get..delete<MockPuppiesRepository>()
      ..delete<CoordinatorController>()
      ..delete<PuppyListController>();
  });

  group('PuppyListController - ', () {
    test('successful initialization', () async {
      // arrange
      // action
      final puppies = _controller.searchedPuppies();
      // assert
      expect(puppies.length, 4);
    });

    test('initialization when Repository throws', () async {
      // arrange
      reset(_mockRepo);
      when(_mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => throw Stub.testErr);
      // action
      await _controller.onReload();
      // assert
      verify(_controller.onRefresh()).called(1);
      expect(_controller.status.isError, true);
    });

    test('filter puppies returns list of puppies', () async {
      // arrange
      reset(_mockRepo);
      when(_mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      await _controller.filterPuppies('est');
      // assert
      final puppies = _controller.searchedPuppies();
      expect(_controller.status.isSuccess, true);
      expect(puppies.length, 1);
      expect(puppies.first, Stub.puppyTest);
    });

    test('filter puppies set filteredBy property', () {
      // arrange
      _controller.filteredBy('');
      reset(_mockRepo);
      when(_mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      _controller.setFilter('est');
      // assert
      expect(_controller.filteredBy.value, 'est');
    });

    test('filter puppies work with debounce', () async {
      // arrange
      reset(_mockRepo);
      when(_mockRepo.getPuppies(query: 'e'))
          .thenAnswer((_) async => Stub.puppiesTest);
      when(_mockRepo.getPuppies(query: 'es'))
          .thenAnswer((_) async => Stub.puppiesTest);
      when(_mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      scheduleMicrotask(() async {
        _controller..setFilter('e')
        ..setFilter('es')
        ..setFilter('est');
      },
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      // assert
      verifyNever(_mockRepo.getPuppies(query: 'e'));
      verifyNever(_mockRepo.getPuppies(query: 'es'));
      verify(_mockRepo.getPuppies(query: 'est')).called(1);
    });

    test('filter puppies returns empty list when Repository throws', () async {
      // arrange
      reset(_mockRepo);
      when(_mockRepo.getPuppies(query: 'dada'))
          .thenAnswer((_) async => throw Stub.testErr);
      // action
      await _controller.filterPuppies('dada');
      // assert
      final puppies = _controller.searchedPuppies();
      expect(puppies.length, 0);
      expect(_controller.status.isEmpty, true);
    });

    test('onReload clear extra fetched details', () async {
      //arrange
      final initValue = _coordinatorController.toClearFetchedExtraDetails.value;
      //action
      await _controller.onReload();
      final newValue = _coordinatorController.toClearFetchedExtraDetails.value;
      //assert
      expect(newValue, initValue + 1);
    });

    test('updatePuppiesWithExtraDetails', () async {
      //arrange
      final puppiesToUpdate = Stub.puppiesWithDetails;
      //action
      _coordinatorController.updatePuppiesWithExtraDetails(puppiesToUpdate);
      final hasExtraDetails = _controller
          .searchedPuppies()
          .firstWhere((puppy) => puppy.id == '1')
          .hasExtraDetails();
      //assert
      expect(hasExtraDetails, isTrue);
    });

    test('onPuppyUpdated - update favorite status', () async {
      //arrange
      final puppyToUpdate = Stub.puppyTestUpdated;
      //action
      _coordinatorController.puppyUpdated(puppyToUpdate);
      final isFavorite = _controller
          .searchedPuppies()
          .firstWhere((puppy) => puppy.name == 'Test')
          .isFavorite;
      //assert
      expect(isFavorite, isTrue);
    });
  });
}
