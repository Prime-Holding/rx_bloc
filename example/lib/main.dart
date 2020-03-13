import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/provider/rx_bloc_provider.dart';
import 'package:flutter_rx_bloc/provider/rx_multi_bloc_provider.dart';

import 'bloc/counter_bloc.dart';
import 'bloc/details_bloc.dart';
import 'repository/details_repository.dart';
import 'widgets/counter_widget.dart';
import 'widgets/details_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RxMultiBlocProvider(
        providers: [
          RxBlocProvider<CounterBlocType>(
            create: (context) => CounterBloc(),
          ),
          RxBlocProvider<DetailsBlocType>(
            create: (context) => DetailsBloc(DetailsRepository()),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('FlutterRxBloc Demo'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: CounterWidget()),
                  const SizedBox(height: 8),
                  Expanded(child: DetailsWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
