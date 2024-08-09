import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';
import 'hotel_manage_bloc_test.mocks.dart';

@GenerateMocks([
  PaginatedHotelsRepository,
  CoordinatorBlocType,
  CoordinatorBlocEvents,
])
void main() {
  late PaginatedHotelsRepository hotelsRepository;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorBlocEvents coordinatorBlocEvents;
  late HotelManageBloc hotelManageBloc;

  void defineWhen({
    Hotel? hotel,
    bool isFavorite = false,
    Exception? exception,
  }) {
    final hotelParam = hotel ?? Stub.hotel1;

    if (exception == null) {
      when(hotelsRepository.favoriteHotel(hotelParam, isFavorite: isFavorite))
          .thenAnswer((_) async => hotelParam.copyWith(isFavorite: isFavorite));
    } else {
      when(hotelsRepository.favoriteHotel(hotelParam, isFavorite: isFavorite))
          .thenAnswer((_) => Future.error(exception));
    }
  }

  setUp(() {
    hotelsRepository = MockPaginatedHotelsRepository();
    coordinatorBloc = MockCoordinatorBlocType();
    coordinatorBlocEvents = MockCoordinatorBlocEvents();

    when(coordinatorBloc.events).thenReturn(coordinatorBlocEvents);

    hotelManageBloc = HotelManageBloc(
      hotelsRepository,
      coordinatorBloc,
    );
  });

  tearDown(() {
    hotelManageBloc.dispose();
  });

  group('test hotel_manage_bloc_dart state isLoading', () {
    rxBlocTest<HotelManageBlocType, bool>(
      'test hotel_manage_bloc_dart state isLoading',
      build: () async {
        defineWhen(hotel: Stub.hotel1, isFavorite: true);
        return hotelManageBloc;
      },
      act: (bloc) async => bloc.events.markAsFavorite(
        hotel: Stub.hotel1,
        isFavorite: true,
      ),
      state: (bloc) => bloc.states.isLoading,
      expect: [false, true, false, true, false],
    );
  });

  group('test hotel_manage_bloc_dart state error', () {
    rxBlocTest<HotelManageBlocType, String>(
      'test hotel_manage_bloc_dart state error',
      build: () async {
        defineWhen(
          exception: Exception('network error'),
          isFavorite: true,
          hotel: Stub.hotel1,
        );

        return hotelManageBloc;
      },
      act: (bloc) async => bloc.events.markAsFavorite(
        hotel: Stub.hotel1,
        isFavorite: true,
      ),
      state: (bloc) => bloc.states.error,
      expect: ['network error'],
    );
  });

  group('test hotel_manage_bloc_dart state favoriteMessage', () {
    rxBlocTest<HotelManageBlocType, String>(
      'test hotel_manage_bloc_dart state favoriteMessage',
      build: () async {
        defineWhen(
          isFavorite: true,
          hotel: Stub.hotel1,
        );
        return hotelManageBloc;
      },
      act: (bloc) async => bloc.events.markAsFavorite(
        hotel: Stub.hotel1,
        isFavorite: true,
      ),
      state: (bloc) => bloc.states.favoriteMessage,
      expect: [
        'Premier Inn Dubai International Airport was added to your favorites'
      ],
    );
  });
}
