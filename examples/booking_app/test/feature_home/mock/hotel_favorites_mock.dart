import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../feature_hotel_favorites/mock/hotel_favorites_mock.mocks.dart';

@GenerateMocks([
  HotelFavoritesBlocStates,
  HotelFavoritesBlocEvents,
  HotelFavoritesBlocType
])
HotelFavoritesBlocType hotelsFavoritesMockFactory() {
  final blocMock = MockHotelFavoritesBlocType();
  final eventsMock = MockHotelFavoritesBlocEvents();
  final statesMock = MockHotelFavoritesBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.count).thenAnswer((_) => Stream.value(0));

  return blocMock;
}
