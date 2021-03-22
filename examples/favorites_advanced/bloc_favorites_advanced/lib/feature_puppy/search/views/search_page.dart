import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';

class SearchPage extends StatelessWidget {
  static const searchPage = 'Search page';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PuppyListBloc, PuppyListState>(
          key: const Key(Keys.puppySearchPage),
          builder: (context, state) {
            switch (state.status) {
              case PuppyListStatus.loading:
                context.read<PuppyListBloc>().add(LoadPuppyListEvent());
                return LoadingWidget(
                  key: const Key('LoadingWidget'),
                );
              case PuppyListStatus.failure:
                return const Center(child: Text('failed to fetch puppies'));
              case PuppyListStatus.success:
                return RefreshIndicator(
                  onRefresh: () {
                    context
                        .read<PuppyListBloc>()
                        .add(ReloadPuppiesEvent(silently: true));
                    return Future.delayed(const Duration(milliseconds: 1000));
                  },
                  child: SafeArea(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 67),
                      itemCount: state.searchedPuppies.length,
                      itemBuilder: (context, index) {
                        final item = state.searchedPuppies[index];
                        return PuppyCard(
                          key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                          onVisible: (puppy) => context
                              .read<PuppyListBloc>()
                              .add(PuppyFetchDetailsEvent(puppy: puppy)),
                          puppy: item,
                        );
                      },
                    ),
                  ),
                );
              default:
                return const Center(child: Text('failed to fetch puppies'));
            }
          });
}
