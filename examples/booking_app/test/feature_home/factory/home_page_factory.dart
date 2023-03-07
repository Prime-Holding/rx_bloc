import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:booking_app/feature_home/views/home_page.dart';
import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../mock/hotel_extra_details_mock.dart';
import '../mock/hotel_favorites_mock.dart';
import '../mock/hotel_manage_mock.dart';
import '../mock/hotel_search_mock.dart';
import '../mock/navigation_bar_mock.dart';

/// Change the parameters according the the needs of the test
Widget homePageFactory({
  required NavigationItemType navigationType,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<HotelSearchBlocType>.value(
            value: hotelSearchMockFactory(),
          ),
          RxBlocProvider<HotelFavoritesBlocType>.value(
            value: hotelsFavoritesMockFactory(),
          ),
          RxBlocProvider<HotelManageBlocType>.value(
            value: hotelManageMockFactory(),
          ),
          RxBlocProvider<HotelsExtraDetailsBlocType>.value(
            value: hotelsExtraDetailsMockFactory(),
          ),
          RxBlocProvider<NavigationBarBlocType>.value(
            value: navigationBarMock(
              navigationType: navigationType,
            ),
          ),
        ],
        child: const HomePage(),
      ),
    );
