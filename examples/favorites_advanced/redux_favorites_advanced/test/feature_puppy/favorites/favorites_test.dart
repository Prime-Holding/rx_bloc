import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/details/models/details_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/redux/epics.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';

import '../../stubs.dart';
import 'favorites_test.mocks.dart';

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
        puppyFavoriteEpic(repository),
      ]),
    );
    store = Store<AppState>(
      appReducer,
      initialState: AppState.initialState(),
      middleware: [epicMiddleware],
    );
  });

  group('Favorite Epic Middleware', () {
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
          AppStateStub.withPuppy1FavoritedAndListed.copyWith(
            detailsState: AppStateStub.initialState.detailsState.copyWith(
              puppy: Stub.puppy1.copyWith(isFavorite: true),
            ),
          ),
        ),
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
          AppStateStub.withPuppy1Error,
        ),
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
        emitsThrough(
          AppStateStub.withPuppy1.copyWith(
            detailsState: DetailsState(isLoading: false, puppy: Stub.puppy1),
          ),
        ),
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
          AppStateStub.withPuppy1Error.copyWith(favoriteCount: 1),
        ),
      );
    });
  });
}
