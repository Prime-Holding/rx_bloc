import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'feature_home/models/navigation_state.dart';
import 'feature_home/redux/reducers.dart';

import 'feature_home/views/home_page.dart';

void main() {
  final store = Store<NavigationState>(
    navStateReducer,
    initialState: NavigationState.initialState(),
  );

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  const MyApp(this.store);

  final Store<NavigationState> store;

  @override
  Widget build(BuildContext context) => StoreProvider<NavigationState>(
        store: store,
        child: MaterialApp(
          title: 'Puppy Redux',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(store),
        ),
      );
}
