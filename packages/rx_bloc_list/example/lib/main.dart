import 'dart:html';

import 'package:example/blocs/user_bloc.dart';
import 'package:example/models/dummy.dart';
import 'package:example/repositories/dummy_repository.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxBlocList Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RxBlocProvider<UserBlocType>(
        create: (context) => UserBloc(DummyRepository()),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage();

  Widget get _customChild => Text(
        'Placeholder text',
        textAlign: TextAlign.center,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Container(
              width: 220,
              height: 220,
              color: Colors.grey,
              child: RxBlocBuilder<UserBlocType, List<Dummy>>(
                state: (bloc) => bloc.states.paginatedList,
                builder: (context, snapshot, bloc) =>
                    RxBlocList<UserBlocType, Dummy>(
                  bloc: bloc,
                  paginatedData: snapshot.hasData ? snapshot.data! : [],
                  builder:
                      <Dummy>(BuildContext context, int index, Dummy item) =>
                          Text('data'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
