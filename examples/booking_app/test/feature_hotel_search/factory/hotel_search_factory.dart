import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart';
import 'package:booking_app/feature_hotel_search/views/hotel_search_page.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/models.dart';

import '../mock/hotel_search_mock.dart';
import '../mock/hotels_extra_details_mock.dart';

/// Change the parameters according the the needs of the test
Widget hotelSearchFactory({
  PaginatedList<Hotel>? hotels,
  String? hotelsFound,
  String? queryFilter,
  DateRangeFilterData? dateRangeFilterData,
  CapacityFilterData? capacityFilterData,
  SortBy? sortedBy,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<HotelsExtraDetailsBlocType>.value(
            value: hotelsExtraDetailsMockFactory(),
          ),
          RxBlocProvider<HotelSearchBlocType>.value(
            value: hotelSearchMockFactory(
              hotels: hotels,
              hotelsFound: hotelsFound,
              queryFilter: queryFilter,
              dateRangeFilterData: dateRangeFilterData,
              capacityFilterData: capacityFilterData,
              sortedBy: sortedBy,
            ),
          ),
        ],
        child: const HotelSearchPage(),
      ),
    );
