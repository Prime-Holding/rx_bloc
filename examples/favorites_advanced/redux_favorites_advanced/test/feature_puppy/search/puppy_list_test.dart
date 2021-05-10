import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/details/models/details_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/redux/epics.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/epics.dart';

import '../../stubs.dart';
import 'puppy_list_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository repository;
  late EpicMiddleware<AppState> epicMiddleware;
  late Store<AppState> store;

  setUp(() {
    repository = MockPuppiesRepository();
    epicMiddleware = EpicMiddleware(
      combineEpics<AppState>([
        fetchPuppiesEpic(repository),
        fetchExtraDetailsEpic(repository),
        puppyFavoriteEpic(repository),
        searchQueryEpic(repository),
      ]),
    );
    store = Store<AppState>(
      appReducer,
      initialState: AppState.initialState(),
      middleware: [epicMiddleware],
    );
  });

  group('Epic Middleware', () {
    test('Fetch puppies success', () {
      when(repository.getPuppies()).thenAnswer((_) async => Stub.puppies123);

      scheduleMicrotask(() {
        store.dispatch(PuppiesFetchRequestedAction());
      });

      expect(
        store.onChange,
        emitsInOrder([
          AppStateStub.initialState,
          AppStateStub.withPuppies123,
        ]),
      );
    });

    test('Fetch puppies error', () {
      when(repository.getPuppies()).thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store.dispatch(PuppiesFetchRequestedAction());
      });

      final state = AppStateStub.initialState;
      expect(
          store.onChange,
          emitsThrough(
            state.copyWith(
              puppyListState: state.puppyListState.copyWith(
                isError: true,
              ),
            ),
          )
          // emitsInOrder([
          //   state,
          //   state.copyWith(
          //     puppyListState: state.puppyListState.copyWith(
          //       isError: true,
          //     ),
          //   ),
          // ]),
          );
    });

    test('Extra details fetch', () {
      when(repository.fetchFullEntities(Stub.puppies123.ids))
          .thenAnswer((_) async => Stub.puppies123ExtraDetails);

      scheduleMicrotask(() {
        store
          ..dispatch(ExtraDetailsFetchRequestedAction(puppy: Stub.puppy1))
          ..dispatch(ExtraDetailsFetchRequestedAction(puppy: Stub.puppy2))
          ..dispatch(ExtraDetailsFetchRequestedAction(puppy: Stub.puppy3));
      });

      final state = AppStateStub.initialState;
      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            puppyListState: state.puppyListState.copyWith(
              puppies: Stub.puppies123ExtraDetails,
            ),
          ),
        ),
        // emitsInOrder([
        //   state,
        //   state,
        //   state,
        //   state.copyWith(
        //     puppyListState: state.puppyListState.copyWith(
        //       puppies: Stub.puppies123ExtraDetails,
        //     ),
        //   ),
        // ]),
      );
    });

    // test('Extra details fetch fail', () async {
    //   when(repository.fetchFullEntities(Stub.puppies12.ids))
    //       .thenAnswer((_) async => throw Stub.testErr);
    //
    //   scheduleMicrotask(() async {
    //     store
    //       ..dispatch(ExtraDetailsFetchRequestedAction(puppy: Stub.puppy1))
    //       ..dispatch(ExtraDetailsFetchRequestedAction(puppy: Stub.puppy2));
    //   });
    //
    //   expect(
    //     store.onChange,
    //     emitsInOrder([
    //       AppStateStub.initialState,
    //       AppStateStub.initialState.copyWith(error: Stub.testErr.toString()),
    //     ]),
    //   );
    // });

    test('Favorite puppy success', () {
      when(repository.favoritePuppy(Stub.puppy1, isFavorite: true))
          .thenAnswer((_) async => Stub.puppy1.copyWith(isFavorite: true));

      scheduleMicrotask(() {
        store.dispatch(
            PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: true));
      });

      expect(
        store.onChange,
        emitsThrough(
          AppStateStub.withPuppy1FavoritedAndListedInDetails,
        ),
        // emitsInOrder([
        //   AppStateStub.initialState,
        //   AppStateStub.withPuppy1Favorited,
        //   AppStateStub.withPuppy1FavoritedAndInDetails,
        //   AppStateStub.withPuppy1FavoritedAndInDetails,
        //   AppStateStub.withPuppy1FavoritedAndInDetails
        //       .copyWith(favoriteCount: 1),
        //   AppStateStub.withPuppy1FavoritedAndInDetails
        //       .copyWith(favoriteCount: 1),
        //   AppStateStub.withPuppy1FavoritedAndListedInDetails,
        // ]),
      );
    });

    test('Favorite puppy error', () {
      when(repository.favoritePuppy(Stub.puppy1, isFavorite: true))
          .thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store.dispatch(
            PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: true));
      });

      expect(
          store.onChange,
          emitsThrough(
            AppStateStub.withPuppy1.copyWith(
              detailsState: DetailsState(puppy: Stub.puppy1),
              error: Stub.testErr.toString(),
            ),
          )
          // emitsInOrder([
          //   AppStateStub.initialState,
          //   AppStateStub.withPuppy1Favorited,
          //   AppStateStub.withPuppy1Favorited,
          //   AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
          //   //exception
          //   AppStateStub.withPuppy1.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1,
          //   AppStateStub.withPuppy1.copyWith(
          //     error: Stub.testErr.toString(),
          //   ),
          // ]),
          );
    });

    test('Unfavorite puppy success', () {
      when(repository.favoritePuppy(Stub.puppy1, isFavorite: true))
          .thenAnswer((_) async => Stub.puppy1.copyWith(isFavorite: true));

      when(repository.favoritePuppy(Stub.puppy1, isFavorite: false))
          .thenAnswer((_) async => Stub.puppy1.copyWith(isFavorite: false));

      scheduleMicrotask(() {
        store
          ..dispatch(
              PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: true))
          ..dispatch(
              PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: false));
      });

      expect(
        store.onChange,
        emitsThrough(AppStateStub.withPuppy1
            .copyWith(detailsState: DetailsState(puppy: Stub.puppy1))),
        // emitsInOrder([
        //   AppStateStub.initialState,
        //   AppStateStub.initialState,
        //   AppStateStub.withPuppy1Favorited,
        //   AppStateStub.withPuppy1Favorited,
        //   AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
        //   AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
        //   AppStateStub.withPuppy1FavoritedAndListed,
        //   AppStateStub.withPuppy1Listed,
        //   AppStateStub.withPuppy1.copyWith(favoriteCount: 1),
        //   AppStateStub.withPuppy1,
        //   AppStateStub.withPuppy1,
        //   AppStateStub.withPuppy1,
        // ]),
      );
    });

    test('Unfavorite puppy error', () {
      when(repository.favoritePuppy(Stub.puppy1, isFavorite: true))
          .thenAnswer((_) async => Stub.puppy1.copyWith(isFavorite: true));

      when(repository.favoritePuppy(Stub.puppy1, isFavorite: false))
          .thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store
          ..dispatch(
              PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: true))
          ..dispatch(
              PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: false));
      });

      expect(
          store.onChange,
          emitsThrough(
            AppStateStub.withPuppy1.copyWith(
              detailsState: DetailsState(puppy: Stub.puppy1),
              favoriteCount: 1,
              error: Stub.testErr.toString(),
            ),
          )
          // emitsInOrder([
          //   AppStateStub.initialState,
          //   AppStateStub.initialState,
          //   AppStateStub.withPuppy1Favorited,
          //   AppStateStub.withPuppy1Favorited,
          //   AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1FavoritedAndListed,
          //   AppStateStub.withPuppy1Listed,
          //   AppStateStub.withPuppy1.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1,
          //   //exception
          //   AppStateStub.withPuppy1,
          //   AppStateStub.withPuppy1,
          //   AppStateStub.withPuppy1.copyWith(favoriteCount: 1),
          //   AppStateStub.withPuppy1.copyWith(
          //     favoriteCount: 1,
          //     error: Stub.testErr.toString(),
          //   ),
          // ]),
          );
    });

    test('Search', () {
      when(repository.getPuppies(query: 'test'))
          .thenAnswer((_) async => [Stub.puppyTest]);

      scheduleMicrotask(() {
        store
          ..dispatch(SearchAction(query: 't'))
          ..dispatch(SearchAction(query: 'te'))
          ..dispatch(SearchAction(query: 'tes'))
          ..dispatch(SearchAction(query: 'test'));
      });

      expect(
        store.onChange,
        emitsInOrder([
          AppStateStub.initialState,
          AppStateStub.initialState,
          AppStateStub.initialState,
          AppStateStub.initialState,
          AppStateStub.initialState.copyWith(
            puppyListState: AppStateStub.initialState.puppyListState.copyWith(
              isLoading: true,
            ),
          ),
          AppStateStub.initialState.copyWith(
            puppyListState: AppStateStub.initialState.puppyListState.copyWith(
              isLoading: true,
              searchQuery: 'test',
            ),
          ),
          AppStateStub.initialState.copyWith(
            puppyListState: AppStateStub.initialState.puppyListState.copyWith(
              isLoading: true,
              searchQuery: 'test',
            ),
          ),
          AppStateStub.initialState.copyWith(
            puppyListState: AppStateStub.initialState.puppyListState.copyWith(
              searchQuery: 'test',
              puppies: [Stub.puppyTest],
            ),
          ),
        ]),
      );
    });
  });
}
