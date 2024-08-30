import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../bloc/counter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Counter sample')),
        body: Center(
          child: RxBlocListener<CounterBlocType, String>(
            state: (bloc) => bloc.states.errors,
            listener: _showError,
            child: RxBlocBuilder<CounterBlocType, int>(
              state: (bloc) => bloc.states.count,
              builder: (context, snapshot, bloc) =>
                  _buildCount(snapshot, context),
            ),
          ),
        ),
        floatingActionButton: RxLoadingBuilder<CounterBlocType>(
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
        ),
      );

  Widget _buildCount(AsyncSnapshot<int> snapshot, BuildContext context) =>
      snapshot.hasData
          ? Text(
              snapshot.data.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            )
          : Container();

  void _showError(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
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
    super.key,
  });

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
