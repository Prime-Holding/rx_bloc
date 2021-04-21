import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_favorites_advanced/base/ui_components/puppy_animated_stream_list_view.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';
// import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/stubs.dart';

class FavoritesPage extends GetView<FavoritePuppiesController> {
  @override
  Widget build(BuildContext context) {
    print('FavoriteState is Success - ${controller.status.isSuccess}');
    return Scaffold(
      body: controller.obx(
        (favoritePuppies) {
          final stream = Stream
              .fromIterable([favoritePuppies?? <Puppy>[]]).asBroadcastStream();
          return Container(
          key: const ValueKey(Keys.puppyFavoritesPage),
          child: PuppyAnimatedStreamListView(
            puppyList:
            stream,
            // controller.streamPuppiesList(),
            // Stream<List<Puppy>>.fromIterable([Stub.puppies123])
            //     .asBroadcastStream(),
            onPuppyPressed: (puppy) =>
                Get.showSnackbar(GetBar(message: 'BUILD TILE ITEM',
                  duration: const Duration(seconds: 2),
                  isDismissible: true,)),
          ),
        );
        },
        onError: (_) => ErrorRetryWidget(
          onReloadTap: () {},
        ),
        onLoading: Container(
          child: const Center(
            child: Text(
              'Loading...',
              style: TextStyle(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
