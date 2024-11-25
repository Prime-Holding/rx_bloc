import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:booking_app/feature_hotel_favorites/views/hotel_favorites_page.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../mock/hotel_favorites_mock.dart';

/// Change the parameters according the the needs of the test
Widget hotelFavoritesFactory({
  required Result<List<Hotel>> favoriteHotelsResult,
  List<Hotel>? initFavoriteHotels,
  int? count,
}) {
  return Scaffold(
    body: MultiProvider(
      providers: [
        RxBlocProvider<HotelFavoritesBlocType>.value(
          value: hotelFavoritesMockFactory(
            favoriteHotels: favoriteHotelsResult,
            count: count,
          ),
        ),
      ],
      child: HotelFavoritesPage(initialList: initFavoriteHotels),
    ),
  );
}
