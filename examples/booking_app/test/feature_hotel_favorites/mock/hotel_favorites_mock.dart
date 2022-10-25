import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'hotel_favorites_mock.mocks.dart';

@GenerateMocks([
  HotelFavoritesBlocStates,
  HotelFavoritesBlocEvents,
  HotelFavoritesBlocType,
])
HotelFavoritesBlocType hotelFavoritesMockFactory({
  Result<List<Hotel>>? favoriteHotels,
  int? count,
}) {
  final blocMock = MockHotelFavoritesBlocType();
  final eventsMock = MockHotelFavoritesBlocEvents();
  final statesMock = MockHotelFavoritesBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.favoriteHotels).thenAnswer(
    (_) => favoriteHotels != null
        ? Stream.value(favoriteHotels)
        : const Stream.empty(),
  );

  when(statesMock.count).thenAnswer(
    (_) => count != null ? Stream.value(count) : const Stream.empty(),
  );

  return blocMock;
}
