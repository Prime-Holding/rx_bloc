import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class FavoritesPage extends GetView<FavoritePuppiesController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: controller.obx(
          (state) => Container(
            key: const ValueKey(Keys.puppyFavoritesPage),
            child: PuppyAnimatedListView(
              puppyList: controller.favoritePuppiesList,
              onFavorite: (puppy, isFavotire) =>
                  Get.find<PuppyManageController>()
                      .markAsFavorite(puppy: puppy, isFavorite: isFavotire),
            ),
          ),
          onError: (_) => ErrorRetryWidget(
            onReloadTap: () => controller.onReload(),
          ),
        ),
      );
}
