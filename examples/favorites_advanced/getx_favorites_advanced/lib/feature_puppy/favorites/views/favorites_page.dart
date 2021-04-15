// import 'package:favorites_advanced_base/core.dart';
// import 'package:favorites_advanced_base/resources.dart';
// import 'package:getx_favorites_advanced/base/ui_components/puppy_animated_list_view.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';
//
// class FavoritesPage extends StatelessWidget {
//   final puppies = Get.find<FavoritePuppiesController>().favoritePuppiesList;
//
//   @override
//   Widget build(BuildContext context) => Column(
//         key: const ValueKey(Keys.puppyFavoritesPage),
//         children: [
//           Expanded(
//             child: PuppyAnimatedListView(
//               puppyList: puppies,
//             onPuppyPressed: (_){},)
//           ),
//         ],
//       );
// }

import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/ui_components/puppy_animated_stream_list_view.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey(Keys.puppyFavoritesPage),
        children: [
          Expanded(
            child: PuppyAnimatedStreamListView(
              puppyList:
                  Get.find<FavoritePuppiesController>().streamPuppiesList(),
              onPuppyPressed: (puppy) {},
            ),
          ),
          // RxResultBuilder<FavoritePuppiesBlocType, List<Puppy>>(
          //   state: (bloc) => bloc.states.favoritePuppies,
          //   buildLoading: (ctx, bloc) => LoadingWidget(),
          //   buildError: (ctx, error, bloc) => ErrorRetryWidget(
          //     onReloadTap: () =>
          //     RxBlocProvider.of<FavoritePuppiesBlocType>(ctx)
          //         .events
          //         .reloadFavoritePuppies(silently: false),
          //   ),
          //   buildSuccess: (ctx, snapshot, bloc) => Container(),
          // )
        ],
      );
}
