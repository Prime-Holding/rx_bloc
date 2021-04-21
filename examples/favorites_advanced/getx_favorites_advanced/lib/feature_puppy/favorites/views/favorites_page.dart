import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import 'package:getx_favorites_advanced/base/ui_components/puppy_automatic_animated_list.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class FavoritesPage extends GetView<FavoritePuppiesController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: controller.obx((_) => Container(
          key: const ValueKey(Keys.puppyFavoritesPage),
          child: Obx(
                () => PuppyAutomaticAnimatedListView(
              puppyList: controller.favoritePuppiesList,
            ),
          ),
        ),
          onError: (error) => ErrorRetryWidget(
            onReloadTap: () => controller.onReload(),
          ),
        ),
      );
}
