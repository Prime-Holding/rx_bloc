import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'feature_home/models/navigation_state.dart';
import 'feature_home/redux/reducers.dart';

import 'feature_home/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<NavigationState> store = Store<NavigationState>(
      navStateReducer,
      initialState: NavigationState.initialState(),
    );
    return MaterialApp(
      title: 'Puppy Redux',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(store),
    );
  }
}
