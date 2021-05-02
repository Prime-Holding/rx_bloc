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
      _mediatorController
          .puppyUpdated(Stub.puppyTestUpdated.copyWith(name: 'UpdatedName'));
      expect(controller.puppy!.value.name, 'UpdatedName');
    });
  });
}
