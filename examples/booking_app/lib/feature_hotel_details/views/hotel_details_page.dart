import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../../base/common_blocs/hotel_manage_bloc.dart';
import '../../../base/ui_components/favorite_message_listener.dart';
import '../blocs/hotel_details_bloc.dart';

part '../ui_components/hotel_details_app_bar.dart';

class HotelDetailsPage extends StatelessWidget {
  const HotelDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          key: keys.detailsPageKey,
          child: Column(
            children: [
              const FavoriteMessageListener(),
              Expanded(
                child: RxBlocBuilder<HotelDetailsBlocType, Hotel>(
                  state: (bloc) => bloc.states.hotel,
                  builder: (context, snapshot, bloc) => snapshot.hasData
                      ? _buildPage(context, bloc, snapshot.data!)
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPage(
    BuildContext context,
    HotelDetailsBlocType bloc,
    Hotel hotel,
  ) =>
      CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leading: const BackButton(key: keys.detailsBackButton),
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
        key: keys.detailsDescriptionKey,
        text: hotel.displayDescription,
        skeletons: 10,
        height: 17,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.withOpacity(0.8),
        ),
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
