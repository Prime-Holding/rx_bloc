import 'package:get/get.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class BaseController extends GetxController{
  BaseController(
      PuppyListController listController,
      FavoritePuppiesController favoritePuppiesController,
      ){
    _listController = listController;
    _favoritePuppiesController = favoritePuppiesController;
  }
  late PuppyListController _listController;
  //will use it soon
  late FavoritePuppiesController _favoritePuppiesController;

  void updatePuppiesWithExtraDetails(RxList<Puppy> lastFetchedPuppies) {
    _listController.updatePuppiesWithExtraDetails(lastFetchedPuppies);
  }

  void puppiesUpdated(List<Puppy> puppy)=> _listController.puppyUpdated(puppy);

  void puppyUpdated(Puppy puppy)=> puppiesUpdated([puppy]);

}