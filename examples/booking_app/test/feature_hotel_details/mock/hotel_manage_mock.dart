import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'hotel_manage_mock.mocks.dart';

@GenerateMocks([
  HotelManageBlocStates,
  HotelManageBlocEvents,
  HotelManageBlocType,
])
HotelManageBlocType hotelManageMockFactory({
  Function()? markAsFavoriteCallback,
}) {
  final blocMock = MockHotelManageBlocType();
  final eventsMock = MockHotelManageBlocEvents();
  final statesMock = MockHotelManageBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  if (markAsFavoriteCallback != null) {
    when(eventsMock.markAsFavorite(
      hotel: anyNamed('hotel'),
      isFavorite: anyNamed('isFavorite'),
    )).thenAnswer(
      (_) => markAsFavoriteCallback(),
    );
  }

  when(statesMock.error).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.isLoading).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.favoriteMessage).thenAnswer(
    (_) => const Stream.empty(),
  );
  return blocMock;
}
