import 'dart:async';

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

  setUp(() async {
    Get.testMode = true;
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    Get.put<PuppiesRepository>(mockRepo);
    when(mockRepo.getPuppies(query: ''))
        .thenAnswer((_) async => Stub.puppies123Test);
    controller = Get.put(PuppyListController(mockRepo, mediatorController));
  });

  tearDown(() {
    Get..delete<MockPuppiesRepository>()
      ..delete<PuppyListController>();
  });

  group('PuppyListController - ', () {
    test('successful initialization', () async {
      // arrange
      // action
      final puppies = controller.searchedPuppies();
      // assert
      expect(puppies.length, 4);
    });

    test('initialization when Repository throws', () async {
      // arrange
      reset(mockRepo);
      when(mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => throw Stub.testErr);
      // action
      await controller.onReload();
      // assert
      verify(controller.onRefresh()).called(1);
      expect(controller.status.isError, true);
    });

    test('filter puppies returns list of puppies', () async {
      // arrange
      reset(mockRepo);
      when(mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      await controller.filterPuppies('est');
      // assert
      final puppies = controller.searchedPuppies();
      expect(controller.status.isSuccess, true);
      expect(puppies.length, 1);
      expect(puppies.first, Stub.puppyTest);
    });

    test('filter puppies set filteredBy property', () {
      // arrange
      controller.filteredBy('');
      reset(mockRepo);
      when(mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      controller.setFilter('est');
      // assert
      expect(controller.filteredBy.value, 'est');
    });

    test('filter puppies work with debounce', () async {
      // arrange
      reset(mockRepo);
      when(mockRepo.getPuppies(query: 'e'))
          .thenAnswer((_) async => Stub.puppiesTest);
      when(mockRepo.getPuppies(query: 'es'))
          .thenAnswer((_) async => Stub.puppiesTest);
      when(mockRepo.getPuppies(query: 'est'))
          .thenAnswer((_) async => Stub.puppiesTest);
      // action
      scheduleMicrotask(() async {
        controller..setFilter('e')
        ..setFilter('es')
        ..setFilter('est');
      },
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      // assert
      verifyNever(mockRepo.getPuppies(query: 'e'));
      verifyNever(mockRepo.getPuppies(query: 'es'));
      verify(mockRepo.getPuppies(query: 'est')).called(1);
    });

    test('filter puppies returns empty list when Repository throws', () async {
      // arrange
      reset(mockRepo);
      when(mockRepo.getPuppies(query: 'dada'))
          .thenAnswer((_) async => throw Stub.testErr);
      // action
      await controller.filterPuppies('dada');
      // assert
      final puppies = controller.searchedPuppies();
      expect(puppies.length, 0);
      expect(controller.status.isEmpty, true);
    });

    test('onReload clear extra fetched details', () async {
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

    test('onPuppyUpdated - update favorite status', () async {
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
