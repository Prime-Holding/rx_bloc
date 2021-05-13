import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/controllers/puppy_details_controller.dart';

import '../../../stubs.dart';

void main() {
  late CoordinatorController _mediatorController;
  late PuppyDetailsController _controller;
  final _puppy = Stub.puppyTestUpdated;

  setUp(() {
    Get.testMode = true;
    _mediatorController = Get.put(CoordinatorController());
    _controller = Get.put(PuppyDetailsController(_puppy, _mediatorController));
  });

  tearDown(() {
    Get..delete<PuppyDetailsController>()..delete<CoordinatorController>();
  });

  group('PuppyDetailsController ', () {
    test('initialization returns correct puppy', () {
      expect(_controller.puppy.value, Stub.puppyTestUpdated);
    });

    test('update edited puppy', () {
      //arrange
      final puppy = Stub.puppyTestUpdated.copyWith(name: 'UpdatedName');
      //action
      _mediatorController
          .puppyUpdated(puppy);
      //assert
      expect(_controller.puppy.value.name, 'UpdatedName');
    });

    test('getters return correct values', () {
    //arrange
    final puppy = Stub.puppyTestUpdated.copyWith(
        name: 'MyName',
        breedCharacteristics: 'Some random text',
        gender: Gender.Female,
        breedType: BreedType.Beagle,
        asset: 'asset');
    //action
    _mediatorController.puppyUpdated(puppy);
    //assert
    expect(_controller.name, 'MyName');
    expect(_controller.characteristics, 'Some random text');
    expect(_controller.gender, 'Female');
    expect(_controller.breed, 'Beagle');
    expect(_controller.asset, 'asset');
    });
  });
}