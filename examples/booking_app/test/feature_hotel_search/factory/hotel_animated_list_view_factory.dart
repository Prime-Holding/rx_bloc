import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart';
import 'package:booking_app/feature_hotel_search/ui_components/hotel_animated_list_view.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../feature_home/mock/hotel_extra_details_mock.dart';
import '../mock/hotel_search_mock.dart';

/// Change the parameters according the the needs of the test
Widget hotelAnimatedListViewFactory({
  required PaginatedList<Hotel> hotels,
  Function(Hotel)? onHotelPressed,
  String? hotelsFound,
  String? queryFilter,
  DateRangeFilterData? dateRangeFilterData,
  CapacityFilterData? capacityFilterData,
  SortBy? sortedBy,
}) {
  return Scaffold(
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
      child: HotelAnimatedListView(
        hotelList: Stream.value(hotels.list).share(),
        onHotelPressed: onHotelPressed,
      ),
    ),
  );
}
