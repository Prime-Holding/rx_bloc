import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../bloc/division_bloc.dart';

String? _numberA, _numberB;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RxBlocProvider<DivisionBlocType>(
              create: (BuildContext ctx) => DivisionBloc(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Number A: '),
                      SizedBox(
                        width: 200,
                        height: 20,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (numA) => _numberA = numA,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Number B: '),
                      SizedBox(
                        width: 200,
                        height: 20,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (numB) => _numberB = numB,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  RxBlocBuilder<DivisionBlocType, bool>(
                    state: (bloc) => bloc.states.isLoading,
                    builder: (ctx, state, bloc) => OutlinedButton(
                      child: Text((state.data ?? false)
                          ? 'Calculating...'
                          : 'Divide A by B'),
                      onPressed: () =>
                          bloc.events.divideNumbers(_numberA, _numberB),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RxBlocBuilder<DivisionBlocType, String>(
                      state: (bloc) => bloc.states.divisionResult,
                      builder: (ctx, state, bloc) =>
                          Text(state.data ?? 'Enter numbers to divide.'),
                    ),
                  ),
                  RxBlocListener<DivisionBlocType, String>(
                    state: (bloc) => bloc.states.errors,
                    listener: (ctx, error) {
                      if (error.isNotEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('Error: $error')));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
