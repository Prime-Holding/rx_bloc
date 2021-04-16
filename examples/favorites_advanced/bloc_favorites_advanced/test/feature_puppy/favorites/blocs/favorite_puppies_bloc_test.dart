import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../../stubs.dart';
import 'favorite_puppies_bloc_test.mocks.dart';

// class MockPuppiesRepository extends Mock implements PuppiesRepository {}

// class MockCoordinatorBloc extends Mock implements CoordinatorBloc {}

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
    'FavoritePuppiesBloc FavoritePuppiesFetchEvent trows',
    build: () {
      when(mockRepo.getFavoritePuppies())
          .thenThrow(Stub.testErr);
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
        // line 73 - 82
        when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
            .thenAnswer((_) async => Stub.isFavoritePuppy3);
        return favoritePuppiesBloc;
      },
      act: (bloc) {
        // line 57 58
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3, isFavorite: true));

        // mockRepo.getFavoritePuppies() Stub.favoritePuppies123);
        // expect(mockRepo.getFavoritePuppies(), Stub.favoritePuppies123);
      },
      expect: () => <FavoritePuppiesState>[
            // line 66 and line 85
            FavoritePuppiesState(favoritePuppies: [Stub.isNotFavoritePuppy3]),
          ],
      verify: (_) {
        // line 64 and 83
        mockCoordinatorBloc
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          )
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          );
      });

  //repo.favoritePuppies() throws exception
  blocTest<FavoritePuppiesBloc, FavoritePuppiesState>(
      'FavoritePuppiesBloc FavoritePuppiesMarkAsFavoriteEvent throws',
      build: () {
        // line 73 - 82
        when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
            .thenThrow(Stub.testErr);
        return favoritePuppiesBloc;
      },
      act: (bloc) {
        // line 57 58
        bloc.add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: Stub.isNotFavoritePuppy3, isFavorite: true));

        // mockRepo.getFavoritePuppies() Stub.favoritePuppies123);
        // expect(mockRepo.getFavoritePuppies(), Stub.favoritePuppies123);
      },
      expect: () => <FavoritePuppiesState>[
            // line 66 and line
            FavoritePuppiesState(favoritePuppies: [Stub.isNotFavoritePuppy3]),
            //line 98
            const FavoritePuppiesState(
                favoritePuppies: [], error: Stub.noInternetConnectionError),
            //Line 105 is not returned, because a state with empty list was
            // already returned above
          ],
      verify: (_) {
        // line 64 and 96
        mockCoordinatorBloc
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
          )
          ..add(
            CoordinatorPuppyUpdatedEvent(Stub.isNotFavoritePuppy3),
          );
      });
}
