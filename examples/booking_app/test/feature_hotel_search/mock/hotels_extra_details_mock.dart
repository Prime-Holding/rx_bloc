import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'hotels_extra_details_mock.mocks.dart';

@GenerateMocks([
  HotelsExtraDetailsStates,
  HotelsExtraDetailsEvents,
  HotelsExtraDetailsBlocType
])
HotelsExtraDetailsBlocType hotelsExtraDetailsMockFactory() {
  final blocMock = MockHotelsExtraDetailsBlocType();
  final eventsMock = MockHotelsExtraDetailsEvents();
  final statesMock = MockHotelsExtraDetailsStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  return blocMock;
}
