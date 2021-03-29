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
            RxBlocBuilder<HotelDetailsBlocType, String>(
              state: (bloc) => bloc.states.imagePath,
              builder: (context, snapshot, bloc) => Hero(
                tag: 'HotelCardAnimationTag ${hotel.id}',
                child: _buildHotelBackgroundImage(
                  snapshot.data ?? hotel.imagePath,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  RxBlocBuilder<HotelDetailsBlocType, String>(
                      state: (bloc) => bloc.states.title,
                      builder: (context, snapshot, bloc) => Text(
                            snapshot.data ?? hotel.title,
                            style: TextStyles.titleTextStyle,
                          )),
                  const SizedBox(height: 5),
                  RxBlocBuilder<HotelDetailsBlocType, String>(
                      state: (bloc) => bloc.states.rating,
                      builder: (context, snapshot, bloc) => Text(
                            snapshot.data ?? '',
                            style: TextStyles.subtitleTextStyle,
                          )),
                  const SizedBox(
                    height: 24,
                  ),
                  RxBlocBuilder<HotelDetailsBlocType, String?>(
                    state: (bloc) => bloc.states.subTitle,
                    builder: (context, snapshot, bloc) => Text(
                      snapshot.data ?? hotel.subTitle,
                      style: TextStyles.subtitleTextStyle,
                    ),
                  ),
                ],
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

  Widget _buildHotelBackgroundImage(String path) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(path),
            fit: BoxFit.cover,
          ),
        ),
      );
}
