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
import 'package:redux_favorite_advanced_sample/feature_puppy/favorites/models/favorite_list_state.dart';
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

      const state = AppStateStub.initialState;
      expect(
        store.onChange,
        emitsInOrder([
          state,
          state.copyWith(
            puppyListState: state.puppyListState.copyWith(
              puppies: Stub.puppies123,
            ),
          ),
        ]),
      );
    });

    test('Fetch puppies error', () {
      when(repository.getPuppies()).thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store.dispatch(PuppiesFetchRequestedAction());
      });

      const state = AppStateStub.initialState;
      expect(
        store.onChange,
        emitsInOrder([
          state,
          state.copyWith(
            puppyListState: state.puppyListState.copyWith(
              isError: true,
            ),
          ),
        ]),
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

      const state = AppStateStub.initialState;
      expect(
        store.onChange,
        emitsInOrder([
          state,
          state,
          state,
          state.copyWith(
            puppyListState: state.puppyListState.copyWith(
              puppies: Stub.puppies123ExtraDetails,
            ),
          ),
        ]),
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
        emitsInOrder([
          AppStateStub.initialState,
          AppStateStub.withPuppy1Favorited,
          AppStateStub.withPuppy1Favorited,
          AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
        ]),
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
        emitsInOrder([
          AppStateStub.initialState,
          AppStateStub.withPuppy1Favorited,
          AppStateStub.withPuppy1,
          AppStateStub.withPuppy1.copyWith(
            error: Stub.testErr.toString(),
          ),
        ]),
      );
    });

    test('Unfavorite puppy', () {
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
        emitsInOrder([
          AppStateStub.initialState,
          AppStateStub.initialState,
          AppStateStub.withPuppy1Favorited,
          AppStateStub.withPuppy1Favorited,
          AppStateStub.withPuppy1Favorited.copyWith(favoriteCount: 1),
          AppStateStub.withPuppy1Favorited.copyWith(
            favoriteListState: FavoriteListState(
              isError: false,
              puppies: [Stub.puppy1.copyWith(isFavorite: true)],
            ),
            favoriteCount: 1,
          ),
          AppStateStub.withPuppy1.copyWith(
            favoriteListState: FavoriteListState(
              isError: false,
              puppies: [Stub.puppy1.copyWith(isFavorite: true)],
            ),
            favoriteCount: 1,
          ),
          AppStateStub.withPuppy1.copyWith(
            favoriteListState: FavoriteListState(
              isError: false,
              puppies: [Stub.puppy1.copyWith(isFavorite: true)],
            ),
            favoriteCount: 1,
          ),
          AppStateStub.withPuppy1.copyWith(
            favoriteListState: FavoriteListState(
              isError: false,
              puppies: [Stub.puppy1.copyWith(isFavorite: true)],
            ),
          ),
          AppStateStub.withPuppy1,
        ]),
      );
    });
  });
}
