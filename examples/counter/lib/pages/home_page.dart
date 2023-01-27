import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../bloc/counter_bloc.dart';

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
                  content: Text(errorMessage),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            ),
            RxBlocBuilder<CounterBlocType, int>(
              state: (bloc) => bloc.states.count,
              builder: (context, snapshot, bloc) => snapshot.hasData
                  ? Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() => RxLoadingBuilder<CounterBlocType>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, tag, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              tooltip: 'Increment',
              iconData: Icons.add,
              onPressed: bloc.events.increment,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagIncrement,
            ),
            const SizedBox(width: 16),
            ActionButton(
              tooltip: 'Decrement',
              iconData: Icons.remove,
              onPressed: bloc.events.decrement,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagDecrement,
            ),
          ],
        ),
      );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.iconData,
    required this.onPressed,
    this.disabled = false,
    this.tooltip = '',
    this.loading = false,
    Key? key,
  }) : super(key: key);

  final bool disabled;
  final bool loading;
  final String tooltip;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CircularProgressIndicator(),
      );
    }

    return FloatingActionButton(
      backgroundColor: disabled ? Colors.blueGrey : Colors.blue,
      onPressed: !disabled ? onPressed : null,
      tooltip: tooltip,
      child: Icon(iconData),
    );
  }
}

extension AsyncSnapshotLoadingWithTag on AsyncSnapshot<LoadingWithTag> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!.loading;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}
