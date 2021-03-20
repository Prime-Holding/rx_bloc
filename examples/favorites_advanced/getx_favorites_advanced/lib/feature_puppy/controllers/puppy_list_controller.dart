import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppyListController extends GetxController {
  PuppyListController(){
    _repository = Get.find<PuppiesRepository>();
    _initPuppies();
  }

  PuppiesRepository _repository;
  final _puppies = [].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  List<Puppy> get searchedPuppies => [..._puppies];

  Future<List<Puppy>> filterPuppies({String query}) async {
    final puppies = await _repository.getPuppies(query: query);
    return puppies;
  }

  Future<void> _initPuppies() async {
    _showLoading();
    try{
      // await Future.delayed(const Duration(seconds: 1));
    final puppies = await _repository.getPuppies();
    print(puppies.length);
    _puppies.assignAll(puppies);
    // throw Exception('Error');
    }catch(e){
      _setError();
      print(e.toString());
    }
    _hideLoading();
  }

  void _showLoading(){
    isLoading.toggle();
  }

  void _hideLoading(){
    isLoading.toggle();
  }

  void _setError(){
    hasError.toggle();
  }

  void clearError(){
    hasError.toggle();
  }

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate){
    puppiesToUpdate.toList().forEach((newPuppyData) {
      final index = _puppies.indexWhere((puppy) => puppy.id == newPuppyData.id);
      _puppies.replaceRange(index, index+1, [newPuppyData]);
    });
  }

}
