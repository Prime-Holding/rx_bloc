import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../feature_hotel_search/ui_components/hotel_animated_list_view.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/hotel_favorites_bloc.dart';

class HotelFavoritesPage extends StatelessWidget {
  const HotelFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey(Keys.hotelFavoritesPage),
        children: [
          Expanded(
            child: HotelAnimatedListView(
              hotelList: context
                  .read<HotelFavoritesBlocType>()
                  .states
                  .favoriteHotels
                  .whereSuccess(),
              onHotelPressed: (hotel) =>
                  context.read<RouterBlocType>().events.pushTo(
                      HotelDetailsRoutes(
                        NavigationItemType.favorites,
                        hotel.id,
                      ),
                      extra: hotel),
            ),
          ),
          RxResultBuilder<HotelFavoritesBlocType, List<Hotel>>(
            state: (bloc) => bloc.states.favoriteHotels,
            buildLoading: (context, bloc) => LoadingWidget(),
            buildError: (context, error, bloc) => ErrorRetryWidget(
              key: const ValueKey('ErrorRetryWidget'),
              onReloadTap: () => context
                  .read<HotelFavoritesBlocType>()
                  .events
                  .reloadFavoriteHotels(silently: false),
            ),
            buildSuccess: (ctx, snapshot, bloc) => Container(
              key: const Key('intentionally_empty_container'),
            ),
          )
        ],
      );
}
