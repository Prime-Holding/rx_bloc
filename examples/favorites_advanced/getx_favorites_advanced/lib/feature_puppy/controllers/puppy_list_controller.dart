import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppyListController extends GetxController with StateMixin {
  PuppyListController(this._repository);

  final PuppiesRepository _repository;
  final _puppies = <Puppy>[].obs;

  @override
  Future<void> onInit() async {
    await _initPuppies();
    super.onInit();
  }

  Future<void> onReload() async {
    change(_puppies, status: RxStatus.loading());
    await updatePuppies();
  }

  Future<void> updatePuppies() async {
    try {
      final allPuppies = await _repository.getPuppies(query: '');
      _puppies
          .where((puppy) => puppy.hasExtraDetails())
          .forEach((oldListPuppy) {
        final index = allPuppies.indexWhere(
            (newFetchedPuppy) => newFetchedPuppy.id == oldListPuppy.id);
        allPuppies.replaceRange(index, index + 1, [oldListPuppy]);
      });
      await Future.delayed(const Duration(seconds: 1));
      _puppies.assignAll(allPuppies);
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
    }
  }

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.toList().forEach((newPuppyData) {
      final index = _puppies.indexWhere((puppy) => puppy.id == newPuppyData.id);
      _puppies.replaceRange(index, index + 1, [newPuppyData]);
    });
  }

  void onPuppyUpdated(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.forEach((puppy) {
      final currentIndex =
          _puppies.indexWhere((element) => element.id == puppy.id);
      _puppies.replaceRange(currentIndex, currentIndex + 1, [puppy]);
    });
  }

  Future<void> _initPuppies() async {
    change(_puppies, status: RxStatus.loading());
    try {
      final puppies = await _repository.getPuppies();
      _puppies.assignAll(puppies);
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
      print(e.toString());
    }
  }
}
