import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_list/models.dart';

import 'hotel_search_mock.mocks.dart';

@GenerateMocks([
  HotelSearchBlocStates,
  HotelSearchBlocEvents,
  HotelSearchBlocType,
])
HotelSearchBlocType hotelSearchMockFactory({
  PaginatedList<Hotel>? hotels,
  PaginatedList<Hotel>? hotelsError,
  String? hotelsFound,
  String? queryFilter,
  DateRangeFilterData? dateRangeFilterData,
  CapacityFilterData? capacityFilterData,
  SortBy? sortedBy,
}) {
  final blocMock = MockHotelSearchBlocType();
  final eventsMock = MockHotelSearchBlocEvents();
  final statesMock = MockHotelSearchBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.hotels).thenAnswer(
    (_) => hotels != null
        ? Stream.value(hotels)
        : const Stream.empty(), //TODO place mocked value
  );

  when(statesMock.hotelsFound).thenAnswer(
    (_) => hotelsFound != null
        ? Stream.value(hotelsFound)
        : const Stream.empty(), //TODO place mocked value
  );

  when(statesMock.queryFilter).thenAnswer(
    (_) => queryFilter != null
        ? Stream.value(queryFilter)
        : const Stream.empty(), //TODO place mocked value
  );

  when(statesMock.dateRangeFilterData).thenAnswer(
    (_) => dateRangeFilterData != null
        ? Stream.value(dateRangeFilterData)
        : const Stream.empty(), //TODO place mocked value
  );

  when(statesMock.capacityFilterData).thenAnswer(
    (_) => capacityFilterData != null
        ? Stream.value(capacityFilterData)
        : const Stream.empty(), //TODO place mocked value
  );

  when(statesMock.sortedBy).thenAnswer(
    (_) => sortedBy != null
        ? Stream.value(sortedBy)
        : const Stream.empty(), //TODO place mocked value
  );

  return blocMock;
}
