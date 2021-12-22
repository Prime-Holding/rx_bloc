import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../list/ui_components/puppy_animated_list_view.dart';
import '../blocs/favorite_puppies_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey(Keys.puppyFavoritesPage),
        children: [
          Expanded(
            child: PuppyAnimatedListView(
              puppyList: RxBlocProvider.of<FavoritePuppiesBlocType>(context)
                  .states
                  .favoritePuppies
                  .whereSuccess(),
              onPuppyPressed: (puppy) =>
                  Navigator.of(context).push(PuppyFlow.route(puppy: puppy)),
            ),
          ),
          RxResultBuilder<FavoritePuppiesBlocType, List<Puppy>>(
            state: (bloc) => bloc.states.favoritePuppies,
            buildLoading: (ctx, bloc) => LoadingWidget(),
            buildError: (ctx, error, bloc) => ErrorRetryWidget(
              onReloadTap: () => RxBlocProvider.of<FavoritePuppiesBlocType>(ctx)
                  .events
                  .reloadFavoritePuppies(silently: false),
            ),
            buildSuccess: (ctx, snapshot, bloc) => Container(),
          )
        ],
      );
}
