import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';
import 'hotel_favorites_test.mocks.dart';

@GenerateMocks([
  PaginatedHotelsRepository,
  CoordinatorBlocType,
  CoordinatorBlocStates,
  CoordinatorBlocEvents
])
void main() {
  late PaginatedHotelsRepository repository;
  late MockCoordinatorBlocType coordinatorMock;
  late MockCoordinatorBlocStates coordinatorStatesMock;
  late MockCoordinatorBlocEvents coordinatorEventsMock;

  void defineWhen({
    required List<Hotel> hotels,
  }) {
    when(repository.getFavoriteHotels()).thenAnswer(
      (realInvocation) => Future.value(hotels),
    );

    when(coordinatorStatesMock.onHotelsUpdated)
        .thenAnswer((_) => const Stream<List<Hotel>>.empty());
  }

  HotelFavoritesBloc hotelFavoritesBloc() => HotelFavoritesBloc(
        repository,
        coordinatorMock,
      );

  setUp(() {
    repository = MockPaginatedHotelsRepository();

    coordinatorMock = MockCoordinatorBlocType();
    coordinatorStatesMock = MockCoordinatorBlocStates();
    coordinatorEventsMock = MockCoordinatorBlocEvents();

    when(coordinatorMock.states).thenReturn(coordinatorStatesMock);
    when(coordinatorMock.events).thenReturn(coordinatorEventsMock);
  });

  group('test hotel_favorites_bloc_dart state favoriteHotels', () {
    rxBlocTest<HotelFavoritesBlocType, Result<List<Hotel>>>(
      'test hotel_favorites_bloc_dart state favoriteHotels',
      build: () async {
        defineWhen(hotels: Stub.paginatedListOneHotel);
        return hotelFavoritesBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.favoriteHotels,
      expect: <Result<List<Hotel>>>[
        Result.success([]),
        Result.loading(),
        Result.success(Stub.paginatedListOneHotel)
      ],
    );
  });

  group('test hotel_favorites_bloc_dart state count', () {
    rxBlocTest<HotelFavoritesBlocType, int>(
        'test hotel_favorites_bloc_dart state count',
        build: () async {
          defineWhen(hotels: Stub.paginatedListOneHotel);
          return hotelFavoritesBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.count,
        expect: []);
  });

  group('test hotel_favorites_bloc_dart dispose method', () {
    test('test hotel_favorites_bloc_dart dispose method', () {
      defineWhen(hotels: Stub.paginatedListOneHotel);
      final hotelsBloc = hotelFavoritesBloc();
      hotelsBloc.dispose();
    });
  });

  group('test hotel_favorites_bloc_extensions updateFavoriteHotels', () {
    rxBlocTest<HotelFavoritesBlocType, Result<List<Hotel>>>(
      'test hotel_favorites_bloc_extensions updateFavoriteHotels',
      build: () async {
        defineWhen(hotels: Stub.paginatedListOneHotel);
        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((_) => Stream.value([Stub.hotel1]));
        return hotelFavoritesBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.favoriteHotels,
      expect: <Result<List<Hotel>>>[
        Result.success([]),
        Result.loading(),
        Result.success(Stub.paginatedListOneHotel)
      ],
    );
  });
}
