import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import 'bloc/counter_bloc.dart';
import 'pages/home_page.dart';
import 'repository/counter_repository.dart';

void main() {
  runApp(const MyApp());
}

// ignore: public_member_api_docs
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
