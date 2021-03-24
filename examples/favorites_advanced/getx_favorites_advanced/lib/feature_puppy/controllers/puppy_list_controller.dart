import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppyListController extends GetxController {
  PuppyListController(PuppiesRepository repository) {
    _repository = repository;
    _initPuppies();
  }

  late PuppiesRepository _repository;
  final _puppies = [].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  List<Puppy> get searchedPuppies => [..._puppies];

  Future<List<Puppy>> filterPuppies({required String query}) async {
    final puppies = await _repository.getPuppies(query: query);
    return puppies;
  }

  Future<void> _initPuppies() async {
    _showLoading();
    try {
      // await Future.delayed(const Duration(seconds: 1));
      final puppies = await _repository.getPuppies();
      _puppies.assignAll(puppies);
      // throw Exception('Error');
    } catch (e) {
      _setError();
      print(e.toString());
    }
    _hideLoading();
  }

  void _showLoading() => isLoading(true);

  void _hideLoading() => isLoading(false);

  void _setError() => hasError(true);

  void clearError() => hasError(false);

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.toList().forEach((newPuppyData) {
      final index = _puppies.indexWhere((puppy) => puppy.id == newPuppyData.id);
      _puppies.replaceRange(index, index + 1, [newPuppyData]);
    });
  }

  void puppyUpdated(List<Puppy> puppiesToUpdate) {
    final copiedPuppies = <Puppy> [..._puppies];
    puppiesToUpdate.forEach((puppy) {
      final currentIndex = copiedPuppies
          .indexWhere((element) => element.id == puppy.id);
      copiedPuppies.replaceRange(currentIndex, currentIndex+1, [puppy]);
    });
    _puppies.assignAll(copiedPuppies);
  }
}
