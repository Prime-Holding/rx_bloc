import 'package:example/blocs/user_bloc.dart';
import 'package:example/models/dummy.dart';
import 'package:example/repositories/dummy_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
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
      home: RxBlocProvider<UserBlocType>(
        create: (context) => UserBloc(repository: DummyRepository()),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: RxPaginatedBuilder<UserBlocType, Dummy>(
            builder: (context, snapshot, bloc) => _buildPaginatedList(snapshot),
            state: (bloc) => bloc.states.paginatedList,
            onBottomScrolled: (bloc) => bloc.events.loadPage(),
            onRefresh: (bloc) async {
              context.read<UserBlocType>().events.loadPage(reset: true);
              //return Future.delayed(Duration(seconds: 1));
              await context.read<UserBlocType>().states.refreshDone;
              return Future.value();
            },
          ),
        ),
      );

  Widget _buildPaginatedList(AsyncSnapshot<PaginatedList<Dummy>> snapshot) {
    if (!snapshot.hasData ||
        (snapshot.hasData && snapshot.data!.isInitialLoading)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final list = snapshot.data!;

    return ListView.builder(
      itemBuilder: (context, index) => itemBuilder(list, index),
      itemCount: list.itemCount,
    );
  }

  Widget itemBuilder(PaginatedList<Dummy> list, int index) {
    if (list.length == index) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 12),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Card(
      child: ListTile(
        title: Text(list[index].name),
      ),
    );
  }
}
