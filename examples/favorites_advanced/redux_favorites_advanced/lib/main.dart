import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/repositories.dart';

import 'base/models/app_state.dart';
import 'base/redux/app_reducer.dart';

import 'feature_home/views/home_view.dart';
import 'feature_puppy/redux/epics.dart';
import 'feature_puppy/search/redux/epics.dart';

void main() {
  final repository = PuppiesRepository(ImagePicker(), ConnectivityRepository());

  final epicMiddleware = EpicMiddleware(
    combineEpics<AppState>([
      fetchPuppiesEpic(repository),
      fetchExtraDetailsEpic(repository),
      puppyFavoriteEpic(repository),
      searchQueryEpic(repository),
    ]),
  );

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [epicMiddleware],
  );

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
          home: HomeView(),
        ),
      );
}
