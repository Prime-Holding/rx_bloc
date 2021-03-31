import 'dart:io';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:booking_app/feature_hotel/details/blocs/hotel_details_bloc.dart';
import 'package:booking_app/feature_hotel/details/ui_components/hotel_details_app_bar.dart';

class HotelDetails extends StatelessWidget {
  const HotelDetails({
    required this.hotel,
    Key? key,
  }) : super(key: key);

  final Hotel hotel;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        key: const ValueKey(Keys.hotelDetailsPage),
        child: Stack(
          children: [
            Hero(
              tag: 'HotelListItem${hotel.id}',
              child: HotelCard(
                hotel: hotel,
                aspectRatio: 1.2,
              ),
            ),
            Positioned(
              child: RxBlocBuilder<HotelDetailsBlocType, Hotel>(
                state: (bloc) => bloc.states.hotel,
                builder: (context, snapshot, bloc) => HotelDetailsAppBar(
                  hotel: snapshot.data ?? hotel,
                ),
              ),
            ),
          ],
        ),
      );
}
