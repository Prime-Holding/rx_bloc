// ignore: public_member_api_docs
import 'package:example/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

class HomePage extends StatelessWidget {
  // ignore: public_member_api_docs
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter sample')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<CounterBlocType, String>(
              state: (bloc) => bloc.states.errors,
              listener: (context, errorMessage) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage ?? ""),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            ),
            RxBlocBuilder<CounterBlocType, int>(
              state: (bloc) => bloc.states.count,
              builder: (context, snapshot, bloc) => snapshot.hasData
                  ? Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() => RxBlocBuilder<CounterBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loadingState.isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(),
              ),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.increment,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      );
}

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}
