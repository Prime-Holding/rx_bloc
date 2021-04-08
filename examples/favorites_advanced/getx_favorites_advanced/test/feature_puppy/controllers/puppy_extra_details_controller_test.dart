import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';

import '../../stubs.dart';
import 'puppy_extra_details_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main(){
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyExtraDetailsController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());
    controller = Get.put(PuppyExtraDetailsController(
        MockPuppiesRepository(), Get.find<MediatorController>()));
  });

}