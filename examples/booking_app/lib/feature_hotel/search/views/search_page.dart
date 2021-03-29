import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:booking_app/base/flow_builders/hotel_flow.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../blocs/hotels_extra_details_bloc.dart';
import '../../blocs/hotel_manage_bloc.dart';
import '../blocs/hotel_list_bloc.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child:
            RxPaginatedBuilder<HotelListBlocType, Hotel>.withRefreshIndicator(
                onBottomScrolled: (bloc) => bloc.events.reload(reset: false),
                onRefresh: (bloc) {
                  bloc.events.reload(reset: true);
                  return bloc.states.refreshDone;
                },
                state: (bloc) => bloc.states.searchedHotels,
                buildSuccess: (context, list, bloc) => RxAnimatedList(
                      listColor:
                          HotelAppTheme.buildLightTheme().backgroundColor,
                      listPadding: const EdgeInsets.only(bottom: 100, top: 10),
                      itemCount: list.itemCount,
                      header: Column(
                        children: <Widget>[
                          SearchBar(),
                          TimeDateBar(),
                        ],
                      ),
                      pinnedHeader: FilterBar(),
                      itemBuilder: (ctx, controller, animation, index) {
                        final item = list.getItem(index);

                        if (item == null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: LoadingWidget(),
                          );
                        }

                        return RxAnimatedListItem(
                          animationController: controller,
                          animation: animation,
                          child: HotelListItem(
                            hotel: item,
                            onCardPressed: (index) => Navigator.of(context)
                                .push(HotelFlow.route(hotel: item)),
                            onFavorite: (index, isFavorite) =>
                                RxBlocProvider.of<HotelManageBlocType>(ctx)
                                    .events
                                    .markAsFavorite(
                                        hotel: item, isFavorite: isFavorite),
                            onVisible: (index) =>
                                RxBlocProvider.of<HotelsExtraDetailsBlocType>(
                                        ctx)
                                    .events
                                    .fetchExtraDetails(item),
                          ),
                        );
                      },
                    ),
                buildLoading: (context, list, bloc) =>
                    LoadingWidget(key: const Key('LoadingWidget')),
                buildError: (context, list, bloc) => ErrorRetryWidget(
                      onReloadTap: () => bloc.events.reload(
                        reset: true,
                        fullReset: true,
                      ),
                    )),
      );
}
