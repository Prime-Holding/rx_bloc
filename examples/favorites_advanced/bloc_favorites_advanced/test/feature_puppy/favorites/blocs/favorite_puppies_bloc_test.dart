import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mock;
import 'package:favorites_advanced_base/repositories.dart';

import '../../../stubs.dart';
import 'favorite_puppies_bloc_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late FavoritePuppiesBloc favoritePuppiesBloc;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    mock
        .when(mockCoordinatorBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    favoritePuppiesBloc = FavoritePuppiesBloc(
      puppiesRepository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

  test('FavoritePuppiesBloc FavoritePuppiesState count getter ', () async {
    mock
        .when(mockRepo.getFavoritePuppies())
        .thenAnswer((_) async => Stub.favoritePuppies);

    favoritePuppiesBloc.add(FavoritePuppiesFetchEvent());

    await Future.delayed(const Duration(milliseconds: 200));

    expect(favoritePuppiesBloc.state.count, 2);
  });

  // Does not mark copyWith as tested
  test(
    'FavoritePuppiesState copyWith',
        () async {
      mock
          .when(mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.favoritePuppies);

      favoritePuppiesBloc.add(FavoritePuppiesFetchEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(
          favoritePuppiesBloc.state.copyWith(
            favoritePuppies: Stub.favoritePuppies,
          ),
          FavoritePuppiesState(favoritePuppies: Stub.favoritePuppies));
    },
  );

  // Does not mark copyWith as tested
  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesState copyWith2',
    build: () {
      mock
          .when(mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.favoritePuppies);
      return favoritePuppiesBloc;
    },
    act: (bloc) async {
      bloc.add(FavoritePuppiesFetchEvent());
    },
    wait: const Duration(milliseconds: 200),
    expect: () => <FavoritePuppiesState>[
      favoritePuppiesBloc.state.copyWith(
        favoritePuppies: Stub.favoritePuppies,
      ),
    ],
  );

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesBloc FavoritePuppiesFetchEvent',
    build: () {
      mock
          .when(mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.favoritePuppies);
      return favoritePuppiesBloc;
    },
    act: (bloc) async {
      bloc.add(FavoritePuppiesFetchEvent());
    },
    wait: const Duration(milliseconds: 200),
    expect: () => <FavoritePuppiesState>[
      FavoritePuppiesState(
        favoritePuppies: Stub.favoritePuppies,
      ),
    ],
  );

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesBloc FavoritePuppiesFetchEvent throws1',
    build: () {
      mock.when(mockRepo.getFavoritePuppies()).thenThrow(Stub.testErr);
      return favoritePuppiesBloc;
    },
    act: (bloc) async {
      bloc.add(FavoritePuppiesFetchEvent());
    },
    wait: const Duration(milliseconds: 200),
    expect: () => <FavoritePuppiesState>[
      const FavoritePuppiesState(
        favoritePuppies: [],
        error: Stub.testErrString,
      ),
    ],
  );

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
      'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent',
      build: () {
        mock
            .when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3,
            isFavorite: true))
            .thenAnswer((_) async => Stub.isFavoritePuppy3);
        return favoritePuppiesBloc;
      },
      act: (bloc) async {
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3,
            isFavorite: true,
            updateException: ''));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => <FavoritePuppiesState>[
        FavoritePuppiesState(favoritePuppies: [Stub.isFavoritePuppy3]),
      ],
      verify: (_) {
        mockCoordinatorBloc
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          )
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          );
      });

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
      'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent throws2',
      build: () {
        mock
            .when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3,
            isFavorite: true))
            .thenThrow(Stub.testErr);
        return FavoritePuppiesBloc(
          puppiesRepository: mockRepo,
          coordinatorBloc: mockCoordinatorBloc,
        );
      },
      act: (bloc) async {
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3,
            isFavorite: true,
            updateException: Stub.testErrString));
      },
      // With wait: const Duration(milliseconds: 200) only the first state
      // is emitted with 400 both state are emitted
      wait: const Duration(milliseconds: 400),
      expect: () => <FavoritePuppiesState>[
        FavoritePuppiesState(
            favoritePuppies: [Stub.isNotFavoritePuppy3],
            error: Stub.testErrString),
        const FavoritePuppiesState(favoritePuppies: [], error: null),
      ],
      verify: (_) {
        mockCoordinatorBloc.add(
          CoordinatorPuppyUpdatedEvent(Stub.isNotFavoritePuppy3),
        );
      });

  //updateException is empty and then an exception is thrown
  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent updateException'
        'is empty and throws',
    build: () {
      mock
          .when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3,
          isFavorite: true))
          .thenThrow(Stub.testErr);
      return FavoritePuppiesBloc(
        puppiesRepository: mockRepo,
        coordinatorBloc: mockCoordinatorBloc,
      );
    },
    act: (bloc) async {
      bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
          puppy: Stub.isNotFavoritePuppy3,
          isFavorite: true,
          updateException: ''));
    },
    wait: const Duration(milliseconds: 400),
    expect: () => <FavoritePuppiesState>[
      const FavoritePuppiesState(
          favoritePuppies: [], error: Stub.testErrString),
      FavoritePuppiesState(
          favoritePuppies: [Stub.isNotFavoritePuppy3], error: null),
    ],
  );
}

