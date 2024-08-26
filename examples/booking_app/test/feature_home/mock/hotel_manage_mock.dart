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
  String? favoriteMessage,
}) {
  final blocMock = MockHotelManageBlocType();
  final eventsMock = MockHotelManageBlocEvents();
  final statesMock = MockHotelManageBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.error).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.isLoading).thenAnswer(
    (_) => const Stream.empty(),
  );

  when(statesMock.favoriteMessage).thenAnswer(
    (_) => favoriteMessage != null
        ? Stream.value(favoriteMessage)
        : const Stream.empty(),
  );

  return blocMock;
}
