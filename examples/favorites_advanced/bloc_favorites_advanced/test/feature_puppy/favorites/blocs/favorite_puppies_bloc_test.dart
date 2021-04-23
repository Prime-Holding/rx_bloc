import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
    favoritePuppiesBloc = FavoritePuppiesBloc(
      puppiesRepository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

  test('getter',(){

  });

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesBloc FavoritePuppiesFetchEvent',
    build: () {
      when(mockRepo.getFavoritePuppies())
          .thenAnswer((_) async => Stub.favoritePuppies);
      return favoritePuppiesBloc;
    },
    act: (bloc) {
      bloc.add(FavoritePuppiesFetchEvent());
    },
    expect: () => <FavoritePuppiesState>[
      FavoritePuppiesState(
        favoritePuppies: Stub.favoritePuppies,
      ),
    ],
  );

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
    'FavoritePuppiesBloc FavoritePuppiesFetchEvent throws',
    build: () {
      when(mockRepo.getFavoritePuppies()).thenThrow(Stub.testErr);
      return favoritePuppiesBloc;
    },
    act: (bloc) {
      bloc.add(FavoritePuppiesFetchEvent());
    },
    expect: () => <FavoritePuppiesState>[
      const FavoritePuppiesState(
        favoritePuppies: [],
        error: Stub.noInternetConnectionError,
      ),
    ],
  );

  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
      'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent',
      build: () {
        when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
            .thenAnswer((_) async => Stub.isFavoritePuppy3);
        return favoritePuppiesBloc;
      },
      act: (bloc) {
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3, isFavorite: true));
      },
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
      'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent throws',
      build: () {
        when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
            .thenThrow(Stub.testErr);
        return favoritePuppiesBloc;
      },
      act: (bloc) {
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3, isFavorite: true));
      },
      expect: () => <FavoritePuppiesState>[
            const FavoritePuppiesState(
                favoritePuppies: [], error: Stub.noInternetConnectionError),
          ],
      verify: (_) {
        mockCoordinatorBloc
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          )
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isNotFavoritePuppy3),
          );
      });
}
