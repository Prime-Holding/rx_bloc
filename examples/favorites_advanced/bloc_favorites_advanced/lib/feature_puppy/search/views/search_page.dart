import 'package:bloc_sample/base/flow_builders/puppy_flow.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_mark_as_favorite_bloc.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const searchPage = 'Search page';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PuppyListBloc, PuppyListState>(
          key: const Key(Keys.puppySearchPage),
          builder: (context, state) {
            switch (state.status) {
              case PuppyListStatus.initial:
                return _buildPuppyListStatusInitial(context);
              case PuppyListStatus.failure:
                return _buildPuppyListStatusFailure(context);
              case PuppyListStatus.success:
              case PuppyListStatus.reloading:
                return _buildPuppyListStatusReloading(context, state);
              default:
                return _buildPuppyListStatusFailure(context);
            }
          });

  RefreshIndicator _buildPuppyListStatusReloading(
          BuildContext context, PuppyListState state) =>
      RefreshIndicator(
        onRefresh: () {
          context.read<PuppyListBloc>().add(ReloadPuppiesEvent());
          return Future.delayed(const Duration(seconds: 1));
        },
        child: SafeArea(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 67),
              itemCount: state.searchedPuppies!.length,
              itemBuilder: (context, index) {
                final item = state.searchedPuppies![index];
                return PuppyCard(
                  key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                  onVisible: (puppy) => context
                      .read<PuppiesExtraDetailsBloc>()
                      .add(FetchPuppyExtraDetailsEvent(puppy)),
                  puppy: item,
                  onCardPressed: (puppy) {
                    Navigator.of(context).push(PuppyFlow.route(puppy: puppy));
                  },
                  // When we click the favorite_border icon we receive
                  // isFavorite true
                  onFavorite: (puppy, isFavorite) => context
                      .read<PuppyMarkAsFavoriteBloc>()
                      .add(PuppyMarkAsFavoriteEvent(
                          puppy: puppy, isFavorite: isFavorite)),
                );
              }),
        ),
      );

  // Display try again button to reload
  ErrorRetryWidget _buildPuppyListStatusFailure(BuildContext context) =>
      ErrorRetryWidget(
          onReloadTap: () =>
              context.read<PuppyListBloc>().add(LoadPuppyListEvent()));

  LoadingWidget _buildPuppyListStatusInitial(BuildContext context) =>
      LoadingWidget(
        key: const Key('LoadingWidget'),
      );
}
