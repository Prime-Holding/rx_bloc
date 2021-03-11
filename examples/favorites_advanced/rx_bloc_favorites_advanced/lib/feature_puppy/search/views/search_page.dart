import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/flow_builders/puppy_flow.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/keys.dart';

import '../../blocs/puppies_extra_details_bloc.dart';
import '../../blocs/puppy_manage_bloc.dart';
import '../blocs/puppy_list_bloc.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      RxResultBuilder<PuppyListBlocType, List<Puppy>>(
        key: const Key(Keys.puppySearchPage),
        state: (bloc) => bloc.states.searchedPuppies,
        buildLoading: (ctx, bloc) => LoadingWidget(
          key: const Key('LoadingWidget'),
        ),
        buildError: (ctx, error, bloc) => ErrorRetryWidget(
          onReloadTap: () => RxBlocProvider.of<PuppyListBlocType>(ctx)
              .events
              .reloadFavoritePuppies(silently: false),
        ),
        buildSuccess: (ctx, snapshot, bloc) => RefreshIndicator(
          onRefresh: () {
            bloc.events.reloadFavoritePuppies(silently: true);
            return Future.delayed(const Duration(seconds: 1));
          },
          child: SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 67),
              itemCount: snapshot.length,
              itemBuilder: (ctx, index) {
                final item = snapshot[index];

                return PuppyCard(
                  key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                  onVisible: (puppy) =>
                      RxBlocProvider.of<PuppiesExtraDetailsBlocType>(ctx)
                          .events
                          .fetchExtraDetails(puppy),
                  puppy: item,
                  onCardPressed: (puppy) =>
                      Navigator.of(context).push(PuppyFlow.route(puppy: puppy)),
                  onFavorite: (puppy, isFavorite) =>
                      RxBlocProvider.of<PuppyManageBlocType>(ctx)
                          .events
                          .markAsFavorite(puppy: puppy, isFavorite: isFavorite),
                );
              },
            ),
          ),
        ),
      );
}
