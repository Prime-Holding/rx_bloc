import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/repositories/paginated_puppies_repository.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import '../../../stubs.dart';
import 'puppy_list_bloc_test.mocks.dart';

@GenerateMocks([
  CoordinatorEvents,
  CoordinatorStates,
  CoordinatorBlocType,
  PaginatedPuppiesRepository,
])
void main() {
  late MockCoordinatorBlocType coordinatorMock;
  late MockCoordinatorStates mockCoordinatorStates;
  late MockCoordinatorEvents mockCoordinatorEvents;
  late MockPaginatedPuppiesRepository repositoryMock;

  setUp(() {
    coordinatorMock = MockCoordinatorBlocType();
    mockCoordinatorStates = MockCoordinatorStates();
    mockCoordinatorEvents = MockCoordinatorEvents();

    when(coordinatorMock.states).thenReturn(mockCoordinatorStates);
    when(coordinatorMock.events).thenReturn(mockCoordinatorEvents);

    repositoryMock = MockPaginatedPuppiesRepository();
  });

  group('PuppyListBloc refreshDone', () {
    test('refreshDone', () {
      when(mockCoordinatorStates.onPuppiesUpdated)
          .thenAnswer((_) => const Stream.empty());

      when(repositoryMock.getPuppiesPaginated(
        pageSize: 10,
        page: 1,
        query: '',
      )).thenAnswer(
        (_) async => PaginatedList(list: Stub.puppies12, pageSize: 10),
      );

      final bloc = PuppyListBloc(repositoryMock, coordinatorMock);
      expect(bloc.states.refreshDone, completion(null));
    });

    test('dispose', () {
      when(mockCoordinatorStates.onPuppiesUpdated)
          .thenAnswer((_) => const Stream.empty());

      when(repositoryMock.getPuppiesPaginated(
        pageSize: 10,
        page: 1,
        query: '',
      )).thenAnswer(
        (_) async => PaginatedList(list: Stub.puppies12, pageSize: 10),
      );

      PuppyListBloc(repositoryMock, coordinatorMock).dispose();
    });
  });

  group('PuppyListBloc searchedPuppies', () {
    rxBlocTest<PuppyListBloc, PaginatedList<Puppy>>(
      // ignore: lines_longer_than_80_chars
      'PuppyListBloc.title searchedPuppies: success triggered by reloadFavoritePuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(mockCoordinatorStates.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppiesPaginated(
          pageSize: 10,
          page: 1,
          query: '',
        )).thenAnswer(
          (_) async => PaginatedList(list: Stub.puppies12, pageSize: 10),
        );

        when(repositoryMock.getPuppiesPaginated(
          pageSize: 10,
          page: 2,
          query: '',
        )).thenAnswer(
          (_) async => PaginatedList(list: Stub.puppies23, pageSize: 10),
        );

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies multiple times
      act: (bloc) async {
        bloc.events.reload(reset: false);
        await bloc.states.refreshDone;
        bloc.events.reload(reset: false);
        await bloc.states.refreshDone;
        bloc.events.reload(reset: false);
        await bloc.states.refreshDone;
      },
      // Make sure the api it's called just once
      expect: <PaginatedList<Puppy>>[
        PaginatedList(list: [], pageSize: 10, isLoading: false),
        PaginatedList(list: [], pageSize: 10, isLoading: true),
        PaginatedList(list: Stub.puppies12, pageSize: 1, isLoading: false),
        PaginatedList(list: Stub.puppies12, pageSize: 1, isLoading: true),
        PaginatedList(
          list: [...Stub.puppies12, ...Stub.puppies23],
          pageSize: 1,
          isLoading: false,
        ),
        PaginatedList(
          list: [...Stub.puppies12, ...Stub.puppies23],
          pageSize: 1,
          isLoading: true,
        ),
        PaginatedList(
          list: [...Stub.puppies12, ...Stub.puppies23, ...Stub.puppies23],
          pageSize: 1,
        ),
      ],
    );

    rxBlocTest<PuppyListBloc, PaginatedList<Puppy>>(
      'PuppyListBloc.title searchedPuppies: success triggered by filterPuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(mockCoordinatorStates.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppiesPaginated(
          pageSize: 10,
          page: 1,
          query: '',
        )).thenAnswer(
          (_) async => PaginatedList(list: Stub.puppies12, pageSize: 10),
        );

        when(repositoryMock.getPuppiesPaginated(
          pageSize: 10,
          page: 1,
          query: 'test',
        )).thenAnswer(
          (_) async => PaginatedList(list: Stub.puppies123, pageSize: 10),
        );

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies and filterPuppies multiple times
      act: (bloc) async => bloc.events
        ..filter(query: '')
        ..filter(query: 'test'),
      // Make sure the api it's called just once
      expect: <PaginatedList<Puppy>>[
        PaginatedList(list: [], pageSize: 10, isLoading: false),
        PaginatedList(list: [], pageSize: 10, isLoading: true),
        PaginatedList(list: Stub.puppies12, pageSize: 1, isLoading: false),
        PaginatedList(list: [], pageSize: 10, isLoading: true),
        PaginatedList(list: Stub.puppies123, pageSize: 1, isLoading: false),
      ],
    );
  });
}
