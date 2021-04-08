import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/epics.dart';

import '../stubs.dart';
import 'puppy_list_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository repository;

  setUp(() {
    repository = MockPuppiesRepository();
  });

  group('Epic Middleware', () {
    test('accepts an Epic that transforms one Action into another', () {
      final epicMiddleware = EpicMiddleware(
        combineEpics<AppState>([
          fetchPuppiesEpic(repository),
          fetchExtraDetailsEpic(repository),
          puppyFavoriteEpic(repository),
        ]),
      );
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initialState(),
        middleware: [epicMiddleware],
      );

      // when(repository.getPuppies())
      //     .thenAnswer((realInvocation) => Future.value(Stub.puppies123));

      when(repository.getPuppies()).thenAnswer((_) async => Stub.puppies123);

      store.dispatch(PuppiesFetchRequestedAction());

      verifyNever(repository.getPuppies());

      //expectLater(actual, matcher)

      // scheduleMicrotask(() {
      //   store.dispatch(PuppiesFetchRequestedAction());
      // });

      //expect(store.onChange, emits(PuppiesFetchSucceededAction));
      //expect(store.state.puppyListState.puppies!.length, 1000000);
    });
  });
}
