import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/base/services/hotels_service.dart';
import 'package:booking_app/feature_hotel_details/blocs/hotel_details_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
//ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';
import 'hotel_details_test.mocks.dart';

@GenerateMocks([
  HotelsService,
  CoordinatorBlocType,
  CoordinatorBlocEvents,
  CoordinatorBlocStates,
  HotelsExtraDetailsBlocType,
  HotelsExtraDetailsBlocEvents,
  HotelsExtraDetailsBlocStates,
])
void main() {
  late HotelsService hotelsServiceMock;
  late CoordinatorBlocType coordinatorMock;
  late CoordinatorBlocStates coordinatorStatesMock;
  late CoordinatorBlocEvents coordinatorEventsMock;

  late HotelsExtraDetailsBlocType hotelsExtraDetailsMock;
  late HotelsExtraDetailsBlocEvents hotelsExtraDetailsEventsMock;
  late HotelsExtraDetailsBlocStates hotelsExtraDetailsStatesMock;

  setUp(() {
    hotelsServiceMock = MockHotelsService();

    coordinatorMock = MockCoordinatorBlocType();
    coordinatorStatesMock = MockCoordinatorBlocStates();
    coordinatorEventsMock = MockCoordinatorBlocEvents();

    hotelsExtraDetailsMock = MockHotelsExtraDetailsBlocType();
    hotelsExtraDetailsEventsMock = MockHotelsExtraDetailsBlocEvents();
    hotelsExtraDetailsStatesMock = MockHotelsExtraDetailsBlocStates();

    when(coordinatorMock.states).thenReturn(coordinatorStatesMock);
    when(coordinatorMock.events).thenReturn(coordinatorEventsMock);

    when(hotelsExtraDetailsMock.states)
        .thenReturn(hotelsExtraDetailsStatesMock);
    when(hotelsExtraDetailsMock.events)
        .thenReturn(hotelsExtraDetailsEventsMock);
  });

  void defineWhen() {
    when(coordinatorStatesMock.onHotelsUpdated)
        .thenAnswer((_) => Stream.value([Stub.hotel1]));
  }

  HotelDetailsBloc hotelDetailsBloc({required String hotelId, Hotel? hotel}) =>
      HotelDetailsBloc(
        coordinatorMock,
        hotelsExtraDetailsMock,
        hotelsServiceMock,
        hotel: hotel,
        hotelId: hotelId,
      );

  group('test hotel_details_bloc_dart state hotel', () {
    rxBlocTest<HotelDetailsBlocType, Hotel>(
      'test hotel_details_bloc_dart state hotel',
      build: () async {
        defineWhen();
        return hotelDetailsBloc(hotel: Stub.hotel1, hotelId: Stub.hotel1.id);
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.hotel,
      expect: [Stub.hotel1],
    );
  });
}
