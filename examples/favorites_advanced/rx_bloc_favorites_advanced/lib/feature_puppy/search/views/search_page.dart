import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../blocs/puppies_extra_details_bloc.dart';
import '../../blocs/puppy_manage_bloc.dart';
import '../blocs/puppy_list_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child:
            RxPaginatedBuilder<PuppyListBlocType, Puppy>.withRefreshIndicator(
          onBottomScrolled: (bloc) => bloc.events.reload(reset: false),
          onRefresh: (bloc) {
            bloc.events.reload(reset: true);
            return bloc.states.refreshDone;
          },
          state: (bloc) => bloc.states.searchedPuppies,
          buildSuccess: (context, list, bloc) => _buildListView(list, context),
          buildLoading: (context, list, bloc) =>
              LoadingWidget(key: const Key('LoadingWidget')),
          buildError: (context, list, bloc) => ErrorRetryWidget(
            onReloadTap: () => bloc.events.reload(
              reset: true,
              fullReset: true,
            ),
          ),
        ),
      );

  ListView _buildListView(
    PaginatedList<Puppy> snapshot,
    BuildContext context,
  ) =>
      ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: snapshot.itemCount,
        itemBuilder: (ctx, index) {
          final item = snapshot.getItem(index);

          if (item == null) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: LoadingWidget(),
            );
          }

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
      );
}
