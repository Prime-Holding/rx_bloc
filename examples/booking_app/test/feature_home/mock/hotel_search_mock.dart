import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../stubs.dart';
import 'hotel_search_mock.mocks.dart';

@GenerateMocks([
  HotelSearchBlocStates,
  HotelSearchBlocEvents,
  HotelSearchBlocType,
])
HotelSearchBlocType hotelSearchMockFactory() {
  final blocMock = MockHotelSearchBlocType();
  final eventsMock = MockHotelSearchBlocEvents();
  final statesMock = MockHotelSearchBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.hotels).thenAnswer(
    (_) => Stream.value(
      Stub.paginatedListHotelThree,
    ),
  );

  when(statesMock.hotelsFound).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.queryFilter).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.dateRangeFilterData).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.capacityFilterData).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.sortedBy).thenAnswer(
    (_) => const Stream.empty(),
  );

  return blocMock;
}
