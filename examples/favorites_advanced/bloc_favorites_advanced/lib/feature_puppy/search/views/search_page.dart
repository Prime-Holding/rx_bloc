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
          // buildWhen: (previous, current) {
          //   final result = previous.status != current.status;
          //   print('buildWhen current.status : ${current.status}');
          //   print('RESULT : $result');
          //   return result;
          // },
          key: const Key(Keys.puppySearchPage),
          builder: (context, state) {
            print('BlocBuilder builder: ${state.status}');
            switch (state.status) {
              case PuppyListStatus.initial:
                return puppyListStatusInitial(context);
              case PuppyListStatus.failure:
                return puppyListStatusFailure();
              case PuppyListStatus.success:
              case PuppyListStatus.reloading:
                return puppyListStatusReloading(context, state);
              default:
                return puppyListStatusFailure();
            }
          });

  RefreshIndicator puppyListStatusReloading(
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
                print('PuppyListStatus  : ${state.status}');
                return PuppyCard(
                  key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                  onVisible: (puppy) => context
                      .read<PuppyListBloc>()
                      .add(PuppyFetchExtraDetailsEvent(puppy: puppy)),
                  puppy: item,
                  onCardPressed: (puppy) {},
                  onFavorite: (puppy, isFavorite) {},
                );
              }),
        ),
      );

  // RefreshIndicator puppyListStatusSuccess(
  //         BuildContext context, PuppyListState state) =>
  //     RefreshIndicator(
  //       onRefresh: () {
  //         context.read<PuppyListBloc>().add(ReloadPuppiesEvent());
  //         return Future.delayed(const Duration(seconds: 1));
  //       },
  //       child: SafeArea(
  //         child: ListView.builder(
  //           padding: const EdgeInsets.only(bottom: 67),
  //           itemCount: state.searchedPuppies!.length,
  //           itemBuilder: (context, index) {
  //             final item = state.searchedPuppies![index];
  //             print('PuppyListStatus.success');
  //
  //             return PuppyCard(
  //               key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
  //               puppy: item,
  //               onCardPressed: (puppy) {},
  //               onFavorite: (puppy, isFavorite) {},
  //             );
  //           },
  //         ),
  //       ),
  //     );

  // RefreshIndicator puppyListAllFetched(
  //     BuildContext context, PuppyListState state) => RefreshIndicator(
  //     onRefresh: () {
  //       context.read<PuppyListBloc>().add(ReloadPuppiesEvent());
  //       return Future.delayed(const Duration(seconds: 1));
  //     },
  //     child: SafeArea(
  //       child: ListView.builder(
  //         padding: const EdgeInsets.only(bottom: 67),
  //         itemCount: state.searchedPuppies!.length,
  //         itemBuilder: (context, index) {
  //           final item = state.searchedPuppies![index];
  //
  //           return PuppyCard(
  //             key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
  //             // onVisible: null,
  //             puppy: item,
  //             onCardPressed: (puppy) {},
  //             onFavorite: (puppy, isFavorite) {},
  //           );
  //         },
  //       ),
  //     ),
  //   );

  Center puppyListStatusFailure() =>
      const Center(child: Text('failed to fetch puppies'));

// create error retry widget

  LoadingWidget puppyListStatusInitial(BuildContext context) {
    context.read<PuppyListBloc>().add(LoadPuppyListEvent());
    return LoadingWidget(
      key: const Key('LoadingWidget'),
    );
  }
}
