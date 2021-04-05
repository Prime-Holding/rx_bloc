import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/models/puppy_list_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/epics.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/reducers.dart';

import 'puppy_list_test.mocks.dart';

//final repository = PuppiesRepository(ImagePicker(), ConnectivityRepository());
@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository repository;

  setUp(() {
    repository = MockPuppiesRepository();
  });

  group('Epic Middleware', () {
    test('accepts an Epic that transforms one Action into another', () async {
      final epicMiddleware = EpicMiddleware(
        combineEpics<AppState>([
          fetchPuppiesEpic(repository),
          fetchExtraDetailsEpic(repository),
        ]),
      );

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initialState(),
        middleware: [epicMiddleware],
      );
      await store.dispatch(PuppiesFetchRequestedAction());

      //expectLater(actual, matcher)

      // scheduleMicrotask(() {
      //   store.dispatch(PuppiesFetchRequestedAction());
      // });

      //expect(store.onChange, emits(PuppiesFetchSucceededAction));
      //expect(store.state.puppyListState.puppies!.length, 1000000);
    });
  });
}
