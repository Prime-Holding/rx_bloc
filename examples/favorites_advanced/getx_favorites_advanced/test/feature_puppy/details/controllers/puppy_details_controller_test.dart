import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/controllers/puppy_details_controller.dart';

import '../../../stubs.dart';

void main() {
  late MediatorController _mediatorController;
  late PuppyDetailsController controller;
  final _puppy = Stub.puppyTestUpdated;

  setUp(() {
    Get.testMode = true;
    _mediatorController = Get.put(MediatorController());
    controller = Get.put(PuppyDetailsController(_puppy, _mediatorController));
  });

  tearDown(() {
    Get..delete<PuppyDetailsController>()..delete<MediatorController>();
  });

  group('PuppyDetailsController ', () {
    test('initialization returns correct puppy', () {
      expect(controller.puppy!.value, Stub.puppyTestUpdated);
    });

    test('update edited puppy', () {
      // arrange
      final puppy = Stub.puppyTestUpdated.copyWith(name: 'UpdatedName');
      // action
      _mediatorController.puppyUpdated(puppy);
      // assert
      expect(controller.puppy!.value.name, 'UpdatedName');
    });

    test('does not update puppy if updatedPuppies do not contain it', () {
      // arrange
      final puppy = Stub.puppy3.copyWith(name: 'UpdatedName');
      // action
      _mediatorController.puppyUpdated(puppy);
      // assert
      expect(controller.puppy!.value.name, 'Test');
    });

  });
}
