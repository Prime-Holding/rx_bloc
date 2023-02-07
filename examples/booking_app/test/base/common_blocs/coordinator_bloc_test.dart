import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';

void main() {
  CoordinatorBloc coordinatorBloc() => CoordinatorBloc();

  group('test coordinator_bloc_dart state onHotelUpdated', () {
    rxBlocTest<CoordinatorBlocType, Hotel>(
      'test coordinator_bloc_dart state onHotelUpdated',
      build: () async => coordinatorBloc(),
      act: (bloc) async => bloc.events.hotelUpdated(Stub.hotel1),
      state: (bloc) => bloc.states.onHotelUpdated,
      expect: [Stub.hotel1],
    );
  });

  group('test coordinator_bloc_dart state onFetchedHotelsWithExtraDetails', () {
    rxBlocTest<CoordinatorBlocType, List<Hotel>>(
      'test coordinator_bloc_dart state onFetchedHotelsWithExtraDetails',
      build: () async => coordinatorBloc(),
      act: (bloc) async => bloc.events.hotelsWithExtraDetailsFetched(
          Stub.paginatedListHotelThreeAndOne.list),
      state: (bloc) => bloc.states.onFetchedHotelsWithExtraDetails,
      expect: [Stub.paginatedListHotelThreeAndOne.list],
    );
  });

  group('test coordinator_bloc_dart state onHotelsUpdated', () {
    rxBlocTest<CoordinatorBlocType, List<Hotel>>(
      'test coordinator_bloc_dart state onHotelsUpdated',
      build: () async => coordinatorBloc(),
      act: (bloc) async => bloc.events
        ..hotelUpdated(Stub.hotel1)
        ..hotelsWithExtraDetailsFetched([Stub.hotel1Loaded]),
      state: (bloc) => bloc.states.onHotelsUpdated,
      expect: [
        [Stub.hotel1],
        [Stub.hotel1Loaded]
      ],
    );
  });
}
