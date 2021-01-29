import 'package:example/pages/home_page.dart';
import 'package:example/repository/counter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import 'bloc/counter_bloc.dart';

void main() {
  runApp(MyApp());
}

// ignore: public_member_api_docs
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RxBlocProvider<CounterBlocType>(
        create: (ctx) => CounterBloc(CounterRepository()),
        child: const HomePage(),
      ),
    );
  }
}
