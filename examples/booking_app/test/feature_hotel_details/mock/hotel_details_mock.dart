import 'package:booking_app/feature_hotel_details/blocs/hotel_details_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hotel_details_mock.mocks.dart';

@GenerateMocks([
  HotelDetailsBlocStates,
  HotelDetailsBlocEvents,
  HotelDetailsBlocType,
])
HotelDetailsBlocType hotelDetailsMockFactory({
  required Hotel hotel,
}) {
  final blocMock = MockHotelDetailsBlocType();
  final eventsMock = MockHotelDetailsBlocEvents();
  final statesMock = MockHotelDetailsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.hotel).thenAnswer(
    (_) => Stream.value(hotel),
  );

  return blocMock;
}
