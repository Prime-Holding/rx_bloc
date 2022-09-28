import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import '../../stubs.dart';
import 'hotel_list_bloc_test.mocks.dart';

@GenerateMocks([
  PaginatedHotelsRepository,
  CoordinatorBlocType,
  CoordinatorEvents,
  CoordinatorStates,
])
void main() {
  late MockPaginatedHotelsRepository repositoryMock;
  late MockCoordinatorBlocType coordinatorMock;
  late MockCoordinatorStates coordinatorStatesMock;
  late MockCoordinatorEvents coordinatorEventsMock;

  setUp(() {
    coordinatorMock = MockCoordinatorBlocType();
    coordinatorStatesMock = MockCoordinatorStates();
    coordinatorEventsMock = MockCoordinatorEvents();

    when(coordinatorMock.states).thenReturn(coordinatorStatesMock);
    when(coordinatorMock.events).thenReturn(coordinatorEventsMock);

    repositoryMock = MockPaginatedHotelsRepository();
  });

  group('HotelListBloc.refreshDone state', () {
    test('refresh done', () {
      _stubRepositoryWithTwoPages(repositoryMock);

      when(coordinatorStatesMock.onHotelsUpdated)
          .thenAnswer((realInvocation) => const Stream.empty());

      final bloc = HotelSearchBloc(repositoryMock, coordinatorMock);

      expect(bloc.refreshDone, completion(null));
    });

    test('dispose', () {
      _stubRepositoryWithTwoPages(repositoryMock);

      when(coordinatorStatesMock.onHotelsUpdated)
          .thenAnswer((realInvocation) => const Stream.empty());

      HotelSearchBloc(repositoryMock, coordinatorMock).dispose();
    });
  });

  group('HotelListBloc.hotelsFound state', () {
    rxBlocTest<HotelSearchBloc, String>(
      // ignore: lines_longer_than_80_chars
      'no hotels, one hotel, two hotels',
      state: (bloc) => bloc.states.hotelsFound,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async {
        bloc.events.reload(reset: false);
        await bloc.states.refreshDone;
        bloc.events.reload(reset: false);
      },
      expect: <String>[
        'No hotels found',
        '1 hotel found',
        '2 hotels found',
      ],
    );
  });

  group('HotelListBloc.hotels state', () {
    rxBlocTest<HotelSearchBloc, PaginatedList<Hotel>>(
      // ignore: lines_longer_than_80_chars
      'Two pages',
      state: (bloc) => bloc.states.hotels,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async {
        bloc.events.reload(reset: false);
        await bloc.states.refreshDone;
        bloc.events.reload(reset: false);
      },
      expect: <PaginatedList<Hotel>>[
        Stub.paginatedListEmpty,
        Stub.paginatedListEmptyLoading,
        Stub.paginatedListOneHotel,
        Stub.paginatedListOneHotelLoading,
        Stub.paginatedListTreeHotels,
      ],
    );

    rxBlocTest<HotelSearchBloc, PaginatedList<Hotel>>(
      // ignore: lines_longer_than_80_chars
      'All filters',
      state: (bloc) => bloc.states.hotels,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithQuery(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(seconds: 1));
        bloc.events
          ..filterByDateRange(dateRange: Stub.dateRange)
          ..filterByCapacity(personCapacity: Stub.one, roomCapacity: Stub.two);

        await Future.delayed(const Duration(seconds: 1));
      },
      expect: <PaginatedList<Hotel>>[
        Stub.paginatedListEmpty,
        Stub.paginatedListEmpty,
        Stub.paginatedListOneHotel,
      ],
    );
  });

  group('HotelListBloc.dateRangeFilterData state', () {
    rxBlocTest<HotelSearchBloc, DateRangeFilterData>(
      // ignore: lines_longer_than_80_chars
      'Empty and non-empty filter',
      state: (bloc) => bloc.states.dateRangeFilterData,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async =>
          bloc.events.filterByDateRange(dateRange: Stub.dateRange),
      expect: <DateRangeFilterData>[
        Stub.dateRangeEmptyFilterData,
        Stub.dateRangeFilterData,
      ],
    );
  });

  group('HotelListBloc.CapacityFilterData state', () {
    rxBlocTest<HotelSearchBloc, CapacityFilterData>(
      // ignore: lines_longer_than_80_chars
      'Two pages',
      state: (bloc) => bloc.states.capacityFilterData,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async => bloc.events
          .filterByCapacity(roomCapacity: Stub.one, personCapacity: Stub.two),
      expect: <CapacityFilterData>[
        Stub.capacityFilterDataEmpty,
        Stub.capacityFilterDataTwoPersonsOneRoom,
      ],
    );
  });

  group('HotelListBloc.sortedBy', () {
    rxBlocTest<HotelSearchBloc, SortBy>(
      // ignore: lines_longer_than_80_chars
      'None, price ask',
      state: (bloc) => bloc.states.sortedBy,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async => bloc.events.sortBy(sort: SortBy.priceAsc),
      expect: <SortBy>[
        SortBy.none,
        SortBy.priceAsc,
      ],
    );
  });

  group('HotelListBloc.queryFilter', () {
    rxBlocTest<HotelSearchBloc, String>(
      // ignore: lines_longer_than_80_chars
      'None, price ask',
      state: (bloc) => bloc.states.queryFilter,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => const Stream.empty());

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async => bloc.events.filterByQuery(Stub.query),
      expect: <String>[
        Stub.emptyQuery,
        Stub.query,
      ],
    );
  });

  group('HotelListBloc.update hotels by coordinator bloc', () {
    rxBlocTest<HotelSearchBloc, PaginatedList<Hotel>>(
      // ignore: lines_longer_than_80_chars
      'Merge hotels',
      state: (bloc) => bloc.states.hotels,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated)
            .thenAnswer((realInvocation) => Stream.value([Stub.hotel3]));

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      expect: <PaginatedList<Hotel>>[
        Stub.paginatedListHotelThree,
        Stub.paginatedListHotelThree,
        Stub.paginatedListHotelThreeAndOne,
      ],
    );

    rxBlocTest<HotelSearchBloc, PaginatedList<Hotel>>(
      // ignore: lines_longer_than_80_chars
      'Favorited hotels',
      state: (bloc) => bloc.states.hotels,
      build: () async {
        /// arrange all prerequisites
        _stubRepositoryWithTwoPages(repositoryMock);

        when(coordinatorStatesMock.onHotelsUpdated).thenAnswer(
          (realInvocation) => Future.delayed(
            const Duration(milliseconds: 1),
            () => [Stub.hotel1Favorited],
          ).asStream(),
        );

        return HotelSearchBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async => Future.delayed(const Duration(milliseconds: 2)),
      expect: <PaginatedList<Hotel>>[
        Stub.paginatedListEmpty,
        Stub.paginatedListEmpty,
        Stub.paginatedListOneHotel,
        Stub.paginatedListOneFavoriteHotel,
        // Stub.paginatedListOneHotel,
        // Stub.paginatedListHotelThree,
        // Stub.paginatedListHotelThreeAndOne,
      ],
    );
  });
}

void _stubRepositoryWithQuery(MockPaginatedHotelsRepository repositoryMock) {
  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(),
    pageSize: 10,
    page: Stub.one,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListOneHotel),
  );

  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(dateRange: Stub.dateRange),
    pageSize: 10,
    page: Stub.one,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListOneHotel),
  );

  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(
        dateRange: Stub.dateRange,
        roomCapacity: Stub.two,
        personCapacity: Stub.one),
    pageSize: 10,
    page: Stub.one,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListOneHotel),
  );

  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(),
    pageSize: 10,
    page: Stub.two,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListTwoHotels),
  );
}

void _stubRepositoryWithTwoPages(MockPaginatedHotelsRepository repositoryMock) {
  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(),
    pageSize: 10,
    page: Stub.one,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListOneHotel),
  );

  when(repositoryMock.getHotelsPaginated(
    filters: HotelSearchFilters(),
    pageSize: 10,
    page: Stub.two,
  )).thenAnswer(
    (realInvocation) => Future.value(Stub.paginatedListTwoHotels),
  );
}
