import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';
import 'file:///C:/Users/snezh/AndroidStudioProjects/rx_bloc/examples/favorites_advanced/getx_favorites_advanced/lib/feature_puppy/search/controllers/puppy_list_controller.dart';

import '../../../stubs.dart';
import 'puppy_list_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MediatorController mediatorController;
  late PuppyListController controller;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mediatorController = Get.put(MediatorController());

    // when(mockRepo.getPuppies(query: ''))
    //     .thenAnswer((_) async => Stub.emptyPuppyList);
    //
    when(mockRepo.getPuppies(query: ''))
        .thenAnswer((realInvocation) async => Stub.puppies123Test);

    controller = Get.put(PuppyListController(
        MockPuppiesRepository(), Get.find<MediatorController>()));
  });

  group('PuppyListController - ', () {
    group('init puppiesList', () {
      test('with internet connection', () async {
        // when(mockRepo.getPuppies(query: '123'))
        //     .thenAnswer((_) async => Stub.puppies123Test);
        final  loadedPuppies = controller.searchedPuppies();
        expect(loadedPuppies.length, equals(0));
        // final isSuccess = controller.status.isSuccess;
        // assert(isSuccess, 'must be true');
      });
    });
  });
}
