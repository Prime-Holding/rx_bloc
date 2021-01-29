import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../stubs.dart';

void main() {
  CoordinatorBlocType coordinatorMock;
  PuppiesRepository repositoryMock;

  setUp(() {
    coordinatorMock = CoordinatorBlocMock();
    repositoryMock = PuppiesRepositoryMock();
  });

  group('PuppyListBloc searchedPuppies', () {
    rxBlocTest<PuppyListBloc, Result<List<Puppy>>>(
      'PuppyListBloc.title searchedPuppies: '
      'success triggered by reloadFavoritePuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppies())
            .thenAnswer((_) async => Stub.puppies12);

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies multiple times
      act: (bloc) async {
        bloc.events.reloadFavoritePuppies(silently: false);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.reloadFavoritePuppies(silently: false);
        await Future.delayed(const Duration(milliseconds: 700));
      },
      // Make sure the api it's called just once
      expect: <Result<List<Puppy>>>[
        Result.success([]),
        Result.loading(),
        Result.success(Stub.puppies12),
      ],
    );

    rxBlocTest<PuppyListBloc, Result<List<Puppy>>>(
      'PuppyListBloc.title searchedPuppies: '
      'success triggered by filterPuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated)
            .thenAnswer((_) => const Stream.empty());

        when(repositoryMock.getPuppies(query: ''))
            .thenAnswer((_) async => Stub.puppies123);

        when(repositoryMock.getPuppies(query: 'test'))
            .thenAnswer((_) async => Stub.puppies12);

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      // Call reloadFavoritePuppies and filterPuppies multiple times
      act: (bloc) async {
        bloc.events.filterPuppies(query: '');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.filterPuppies(query: 'test');
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
    rxBlocTest<PuppyListBloc, Result<List<Puppy>>>(
      'PuppyListBloc.title searchedPuppies:'
      'success triggered by reloadFavoritePuppies',
      state: (bloc) => bloc.states.searchedPuppies,
      build: () async {
        when(repositoryMock.getPuppies())
            .thenAnswer((_) async => Stub.puppies123Test);

        when(coordinatorMock.states.onPuppiesUpdated)
            .thenAnswer((_) => Stub.delayed(Stub.puppiesTestUpdated, 800));

        return PuppyListBloc(repositoryMock, coordinatorMock);
      },
      act: (bloc) async {
        bloc.events.reloadFavoritePuppies(silently: false);
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
