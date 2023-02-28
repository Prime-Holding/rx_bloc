import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hotel_extra_details_mock.mocks.dart';

@GenerateMocks([
  HotelsExtraDetailsBlocType,
  HotelsExtraDetailsBlocEvents,
  HotelsExtraDetailsBlocStates,
])
HotelsExtraDetailsBlocType hotelsExtraDetailsMockFactory() {
  final blocMock = MockHotelsExtraDetailsBlocType();
  final eventsMock = MockHotelsExtraDetailsBlocEvents();
  final statesMock = MockHotelsExtraDetailsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  return blocMock;
}
