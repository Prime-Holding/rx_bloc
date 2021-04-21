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
        (favoritePuppies) =>
            // const Center(
            //   child:const Text(
            //     'SUCCESS...',
            //     style: TextStyle(fontSize: 50),
            //   ),
            // ),

            Container(
          key: const ValueKey(Keys.puppyFavoritesPage),
          child: PuppyAnimatedStreamListView(
            puppyList:
            controller.favoritePuppiesRxList
                .stream.map((event) => event ?? <Puppy>[]),
            // controller.streamPuppiesList(),
            // Stream<List<Puppy>>.fromIterable([Stub.puppies123])
            //     .asBroadcastStream(),
            // .favoritePuppiesRxList.stream
            //                 .asBroadcastStream()
            //                 .asyncMap((event) => event ?? <Puppy>[]),
            onPuppyPressed: (puppy) {},
          ),
        ),
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
