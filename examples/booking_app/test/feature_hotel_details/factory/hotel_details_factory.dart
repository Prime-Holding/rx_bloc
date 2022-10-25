import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel_details/blocs/hotel_details_bloc.dart';
import 'package:booking_app/feature_hotel_details/views/hotel_details_page.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../feature_hotel_search/mock/hotels_extra_details_mock.dart';
import '../mock/hotel_details_mock.dart';
import '../mock/hotel_manage_mock.dart';

/// Change the parameters according the the needs of the test
Widget hotelDetailsFactory({
  required Hotel hotel,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<HotelManageBlocType>.value(
            value: hotelManageMockFactory(),
          ),
          RxBlocProvider<HotelsExtraDetailsBlocType>.value(
            value: hotelsExtraDetailsMockFactory(),
          ),
          RxBlocProvider<HotelDetailsBlocType>.value(
            value: hotelDetailsMockFactory(
              hotel: hotel,
            ),
          ),
        ],
        child: HotelDetailsPage(hotel: hotel),
      ),
    );
