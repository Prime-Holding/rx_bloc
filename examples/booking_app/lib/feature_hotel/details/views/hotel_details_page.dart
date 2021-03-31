import 'package:booking_app/feature_hotel/details/ui_components/hotel_details_app_bar.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/feature_hotel/blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel/blocs/hotel_manage_bloc.dart';
import 'package:booking_app/feature_hotel/details/blocs/hotel_details_bloc.dart';
import 'package:booking_app/feature_hotel/details/ui_components/hotel_details.dart';

part 'hotel_details_providers.dart';

class HotelDetailsPage extends StatelessWidget {
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
  Widget build(BuildContext context) => Scaffold(
        body: HotelDetails(hotel: _hotel),
      );
}
