import 'dart:async';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

class PuppyExtraDetailsController extends GetxController {
  final _repository = Get.find<PuppiesRepository>();
  final lastFetchedPuppies = [].obs;

  Future<void> fetchExtraDetails(Puppy puppy) async {
    print('in function body');
    final streamController = PublishSubject<Puppy>();
    // ignore: cascade_invocations
    streamController.add(puppy);
    final collectedPuppiesData = streamController
        .bufferTime(const Duration(milliseconds: 100))
        .map((puppy) => puppy.whereNoExtraDetails())
        .where((puppies) => puppies.isNotEmpty)
        .flatMap(
            (value) => _repository.fetchFullEntities(value.ids).asStream());
    lastFetchedPuppies.bindStream(collectedPuppiesData);
    Get.find<PuppyListController>()
        .updatePuppiesWithExtraDetails(lastFetchedPuppies.toList());
    await streamController.close();
  }
}
