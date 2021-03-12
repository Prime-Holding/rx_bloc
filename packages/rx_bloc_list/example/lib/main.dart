import 'package:example/repositories/dummy_repository.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

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
      home: MyHomePage(),
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
              child: RxBlocList(
                dataRepository: DummyRepository(),
                builder: (context, index, item) => Container(
                  child: _customChild,
                  color: index % 2 == 0 ? Colors.white30 : Colors.yellow,
                ),
                onRefresh: () {
                  debugPrint("Refreshed!");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
