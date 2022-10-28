import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
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
  CoordinatorBlocType,
  CoordinatorBlocEvents,
  CoordinatorBlocStates,
])
void main() {
  late CoordinatorBlocType coordinatorMock;
  late CoordinatorBlocStates coordinatorStatesMock;
  late CoordinatorBlocEvents coordinatorEventsMock;

  setUp(() {
    coordinatorMock = MockCoordinatorBlocType();
    coordinatorStatesMock = MockCoordinatorBlocStates();
    coordinatorEventsMock = MockCoordinatorBlocEvents();

    when(coordinatorMock.states).thenReturn(coordinatorStatesMock);
    when(coordinatorMock.events).thenReturn(coordinatorEventsMock);
  });

  void defineWhen() {
    when(coordinatorStatesMock.onHotelsUpdated)
        .thenAnswer((_) => Stream.value([Stub.hotel1]));
  }

  HotelDetailsBloc hotelDetailsBloc({required Hotel hotel}) => HotelDetailsBloc(
        coordinatorMock,
        hotel: hotel,
      );

  group('test hotel_details_bloc_dart state hotel', () {
    rxBlocTest<HotelDetailsBlocType, Hotel>(
      'test hotel_details_bloc_dart state hotel',
      build: () async {
        defineWhen();
        return hotelDetailsBloc(hotel: Stub.hotel1);
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.hotel,
      expect: [Stub.hotel1],
    );
  });
}
