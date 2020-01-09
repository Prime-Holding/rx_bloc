import 'package:example/bloc/counter_bloc.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/provider/rx_bloc_provider.dart';

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: StreamBuilder<String>(
                    stream: RxBlocProvider.of<CounterBlocType>(context)
                        .states
                        .count,
                    builder: (context, snapshot) => Text(
                      snapshot.data ?? '',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildButton(
                    action: RxBlocProvider.of<CounterBlocType>(context)
                        .events
                        .increment,
                    context: context,
                    isEnabled: RxBlocProvider.of<CounterBlocType>(context)
                        .states
                        .incrementEnabled,
                    text: 'Increment',
                  ),
                  const SizedBox(width: 16),
                  _buildButton(
                    action: RxBlocProvider.of<CounterBlocType>(context)
                        .events
                        .decrement,
                    context: context,
                    isEnabled: RxBlocProvider.of<CounterBlocType>(context)
                        .states
                        .decrementEnabled,
                    text: 'Decrement',
                  )
                ],
              )
            ],
          ),
        ),
      );

  StreamBuilder<bool> _buildButton({
    @required BuildContext context,
    @required Stream<bool> isEnabled,
    @required VoidCallback action,
    @required String text,
  }) {
    return StreamBuilder<bool>(
        stream: isEnabled,
        builder: (context, snapshot) {
          return Expanded(
            child: RaisedButton(
              child: Text(text),
              onPressed: (snapshot.data ?? false) ? action : null,
            ),
          );
        });
  }
}
