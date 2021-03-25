import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppyListController extends GetxController {
  PuppyListController(PuppiesRepository repository) {
    _repository = repository;
    _initPuppies();
  }

  late PuppiesRepository _repository;
  final _puppies = <Puppy>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  List<Puppy> get searchedPuppies => [..._puppies];

  Future<void> onReload() async {
    _clearError();
    _showLoading();
    await Future.delayed(const Duration(seconds: 1));
    await updatePuppies();
    _hideLoading();
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
    } catch (e) {
      _setError();
    }
  }

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.toList().forEach((newPuppyData) {
      final index = _puppies.indexWhere((puppy) => puppy.id == newPuppyData.id);
      _puppies.replaceRange(index, index + 1, [newPuppyData]);
    });
  }

  void onPuppyUpdated(List<Puppy> puppiesToUpdate) {
    final copiedPuppies = <Puppy>[..._puppies];
    puppiesToUpdate.forEach((puppy) {
      final currentIndex =
          copiedPuppies.indexWhere((element) => element.id == puppy.id);
      copiedPuppies.replaceRange(currentIndex, currentIndex + 1, [puppy]);
    });
    _puppies.assignAll(copiedPuppies);
  }

  Future<void> _initPuppies() async {
    _showLoading();
    try {
      final puppies = await _repository.getPuppies();
      _puppies.assignAll(puppies);
    } catch (e) {
      _setError();
      print(e.toString());
    }
    _hideLoading();
  }

  void _showLoading() => isLoading(true);

  void _hideLoading() => isLoading(false);

  void _setError() => hasError(true);

  void _clearError() => hasError(false);
}
