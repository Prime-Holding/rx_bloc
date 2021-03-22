import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/sagas.dart';
import 'package:redux_saga/redux_saga.dart';

import 'base/models/app_state.dart';
import 'base/redux/app_reducer.dart';

import 'feature_home/views/home_page.dart';

void main() {
  final sagaMiddleware = createSagaMiddleware();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [applyMiddleware(sagaMiddleware)],
  );

  sagaMiddleware
    ..setStore(store)
    ..run(puppiesSaga)
    ..run(extraDetailsSaga);

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  const MyApp(this.store);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Puppy Redux',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        ),
      );
}
