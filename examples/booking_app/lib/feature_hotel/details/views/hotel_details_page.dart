import 'package:booking_app/feature_hotel/details/ui_components/hotel_details_app_bar.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/feature_hotel/blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel/blocs/hotel_manage_bloc.dart';
import 'package:booking_app/feature_hotel/details/blocs/hotel_details_bloc.dart';
import 'package:skeleton_text/skeleton_text.dart';

part 'hotel_details_providers.dart';

class HotelDetailsPage extends StatefulWidget {
  const HotelDetailsPage({
    required Hotel hotel,
    Key? key,
  })  : _hotel = hotel,
        super(key: key);

  static PageRoute route({required Hotel hotel}) => MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RxMultiBlocProvider(
          providers: _getProviders(hotel),
          child: HotelDetailsPage(hotel: hotel),
        ),
        // fullscreenDialog: true,
      );

  final Hotel _hotel;

  @override
  _HotelDetailsPageState createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  @override
  void initState() {
    // context.read<HotelsExtraDetailsBlocType>().events.fetchExtraDetails(
    //       widget._hotel,
    //       allProps: true,
    //     );

    context
        .read<HotelsExtraDetailsBlocType>()
        .events
        .fetchExtraDetails(widget._hotel, allProps: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          key: const ValueKey(Keys.hotelDetailsPage),
          child: RxBlocBuilder<HotelDetailsBlocType, Hotel>(
            state: (bloc) => bloc.states.hotel,
            builder: (context, snapshot, bloc) =>
                snapshot.hasData ? _build(bloc, snapshot.data!) : Container(),
          ),
        ),
      );

  Widget _build(HotelDetailsBlocType bloc, Hotel hotel) => Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'HotelListItem${hotel.id}',
                child: HotelCard(
                  hotel: hotel,
                  aspectRatio: 1.2,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              Positioned(child: HotelDetailsAppBar(hotel: hotel)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                SkeletonText(
                  text: hotel.displayDescription,
                  // text: null,
                  skeletons: 10,
                  height: 17,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
                _buildHotelFeatures(hotel)
              ],
            ),
          )
        ],
      );

  Widget _buildHotelFeatures(Hotel hotel) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: hotel.displayFeatures == null
            ? Container()
            : Wrap(
                children: hotel.displayFeatures!
                    .map(
                      (hotelFeature) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Chip(
                          label: Text(hotelFeature),
                        ),
                      ),
                    )
                    .toList(),
              ),
      );
}
