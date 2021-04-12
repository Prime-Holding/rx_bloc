import 'package:booking_app/base/ui_components/favorite_message_listener.dart';
import 'package:booking_app/feature_hotel/blocs/hotel_manage_bloc.dart';
import 'package:booking_app/feature_hotel/blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel/details/blocs/hotel_details_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

part '../ui_components/hotel_details_app_bar.dart';
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
          child: Column(
            children: [
              const FavoriteMessageListener(),
              Expanded(
                child: RxBlocBuilder<HotelDetailsBlocType, Hotel>(
                  state: (bloc) => bloc.states.hotel,
                  builder: (context, snapshot, bloc) => snapshot.hasData
                      ? _buildPage(bloc, snapshot.data!)
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPage(HotelDetailsBlocType bloc, Hotel hotel) => CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leading: const BackButton(),
            backgroundColor: Colors.transparent,
            actions: _buildTrailingItems(context, hotel),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: HotelImage(aspectRatio: 2, hotel: hotel),
            ),
            expandedHeight: 300,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                HotelHeader(
                  hotel: hotel,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildFooter(hotel),
              ],
            ),
          )
          // _buildFeatures(hotel),
        ],
      );

  Widget _buildFooter(Hotel hotel) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Column(
          children: [
            _buildDescription(hotel),
            _buildFeatures(hotel),
            const SizedBox(height: 16),
          ],
        ),
      );

  Widget _buildDescription(Hotel hotel) => SkeletonText(
        text: hotel.displayDescription,
        skeletons: 10,
        height: 17,
        style: DesignSystem.of(context).typography.bodyText1,
      );

  Widget _buildFeatures(Hotel hotel) => AnimatedSwitcher(
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
