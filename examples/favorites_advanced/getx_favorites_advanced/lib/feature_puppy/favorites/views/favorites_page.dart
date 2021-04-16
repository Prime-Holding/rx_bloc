import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_favorites_advanced/base/ui_components/puppy_animated_stream_list_view.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class FavoritesPage extends GetView<FavoritePuppiesController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: controller.obx(
          (state) => Column(
            key: const ValueKey(Keys.puppyFavoritesPage),
            children: [
              Expanded(
                child: PuppyAnimatedStreamListView(
                  puppyList:
                      Get.find<FavoritePuppiesController>().streamPuppiesList(),
                  onPuppyPressed: (puppy) {},
                ),
              ),
            ],
          ),
          onError: (_) => ErrorRetryWidget(
            onReloadTap: () {},
          ),
        ),
      );
}
