import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
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

  group('PuppyListBloc searchedPuppies', () {
    rxBlocTest<PuppyListBloc, PaginatedList<Puppy>>(
      'PuppyListBloc.title searchedPuppies: '
      'success triggered by reloadFavoritePuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(mockCoordinatorStates.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppiesPaginated()).thenAnswer(
          (_) async => PaginatedList(list: Stub.puppies12, pageSize: 10),
        );

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies multiple times
      act: (bloc) async {
        bloc.events.reload(reset: false);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.reload(reset: false);
        await Future.delayed(const Duration(milliseconds: 700));
      },
      // Make sure the api it's called just once
      expect: <PaginatedList<Puppy>>[
        // Result.success([]),
        // Result.loading(),
        // Result.success(Stub.puppies12),
      ],
    );

    rxBlocTest<PuppyListBloc, PaginatedList<Puppy>>(
      'PuppyListBloc.title searchedPuppies: '
      'success triggered by filterPuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(mockCoordinatorStates.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppies(query: ''))
            .thenAnswer((_) async => Stub.puppies123);

        when(repositoryMock.getPuppies(query: 'test'))
            .thenAnswer((_) async => Stub.puppies12);

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies and filterPuppies multiple times
      act: (bloc) async {
        bloc.events.filter(query: '');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.filter(query: 'test');
        await Future.delayed(const Duration(milliseconds: 700));
      },
      // Make sure the api it's called just once
      expect: <Result<List<Puppy>>>[
        Result.success([]),
        Result.loading(),
        Result.success(Stub.puppies12),
      ],
    );
  });

  group('PuppyListBloc searchedPuppies', () {
    rxBlocTest<PuppyListBloc, PaginatedList<Puppy>>(
      'PuppyListBloc.title searchedPuppies:'
      'success triggered by reloadFavoritePuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(repositoryMock.getPuppies())
            .thenAnswer((_) async => Stub.puppies123Test);

        when(mockCoordinatorStates.onPuppiesUpdated)
            .thenAnswer((_) => Stub.delayed(Stub.puppiesTestUpdated, 800));

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async {
        bloc.events.reload(reset: false);
        await Future.delayed(const Duration(milliseconds: 1200));
      },
      // Make sure the api it's called just once
      expect: <Result<List<Puppy>>>[
        Result.success([]),
        Result.loading(),
        Result.success(Stub.puppies123Test),
        Result.success(Stub.puppies123TestUpdated),
      ],
    );
  });
}
