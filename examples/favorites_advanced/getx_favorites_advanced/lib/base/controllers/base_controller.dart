import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class BaseController extends GetxController {
  BaseController(this._listController, this._favoritePuppiesController);

  final PuppyListController _listController;
  final FavoritePuppiesController _favoritePuppiesController;

  void updatePuppiesWithExtraDetails(RxList<Puppy> lastFetchedPuppies) {
    _listController.updatePuppiesWithExtraDetails(lastFetchedPuppies);
  }

  void puppiesUpdated(List<Puppy> puppiesToUpdate) {
    _listController.onPuppyUpdated(puppiesToUpdate);
    _favoritePuppiesController.updateFavoritePuppies(puppiesToUpdate);
  }

  void puppyUpdated(Puppy puppy) => puppiesUpdated([puppy]);
}
