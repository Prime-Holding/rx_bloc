import 'package:example/bloc/counter_bloc.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/provider/rx_bloc_builder.dart';

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
                  child: RxBlocBuilder<CounterBlocType, String>(
                    state: (bloc) => bloc.states.count,
                    builder: (context, snapshot, bloc) => Text(
                      snapshot.data ?? '',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  RxBlocBuilder<CounterBlocType, bool>(
                    state: (bloc) => bloc.states.incrementEnabled,
                    builder: (context, snapshot, bloc) => Expanded(
                      child: RaisedButton(
                        child: Text('Increment'),
                        onPressed: (snapshot.data ?? false)
                            ? bloc.events.increment
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  RxBlocBuilder<CounterBlocType, bool>(
                    state: (bloc) => bloc.states.decrementEnabled,
                    builder: (context, snapshot, bloc) => Expanded(
                      child: RaisedButton(
                        child: Text('Increment'),
                        onPressed: (snapshot.data ?? false)
                            ? bloc.events.decrement
                            : null,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
