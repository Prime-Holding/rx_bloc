import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_blocs/hotel_manage_bloc.dart';
import '../../base/common_blocs/hotels_extra_details_bloc.dart';

class HotelAnimatedListView extends StatelessWidget {
  const HotelAnimatedListView({
    required Stream<List<Hotel>> hotelList,
    Function(Hotel)? onHotelPressed,
    Key? key,
  })  : _hotelList = hotelList,
        _onHotelPressed = onHotelPressed,
        super(key: key);

  final Function(Hotel)? _onHotelPressed;
  final Stream<List<Hotel>> _hotelList;

  @override
  Widget build(BuildContext context) => AnimatedStreamList<Hotel>(
        streamList: _hotelList,
        primary: true,
        padding: const EdgeInsets.only(bottom: 67),
        itemBuilder: (item, index, context, animation) => _createTile(
          HotelListItem(
            key: Key('${key.toString()}${item.id}'),
            hotel: item,
            onCardPressed: (item) => _onHotelPressed?.call(item),
            onFavorite: (hotel, isFavorite) =>
                RxBlocProvider.of<HotelManageBlocType>(context)
                    .events
                    .markAsFavorite(hotel: hotel, isFavorite: isFavorite),
          ),
          animation,
        ),
        itemRemovedBuilder: (item, index, context, animation) =>
            _createRemovedTile(
          HotelListItem(
            key: Key('${key.toString()}${item.id}'),
            hotel: item,
            onFavorite: (_, isFavorite) {},
            onCardPressed: (hotel) {},
            onVisible: (hotel) => context
                .read<HotelsExtraDetailsBlocType>()
                .events
                .fetchExtraDetails(hotel),
          ),
          animation,
        ),
      );

  Widget _createTile(HotelListItem item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );

  Widget _createRemovedTile(HotelListItem item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );
}
