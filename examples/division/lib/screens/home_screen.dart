import 'package:example/bloc/division_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

String _numberA, _numberB;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: RxBlocProvider<DivisionBlocType>(
              create: (BuildContext ctx) => DivisionBloc(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Number A: '),
                      Container(
                        width: 200,
                        height: 20,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (numA) => _numberA = numA,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Number B: '),
                      Container(
                        width: 200,
                        height: 20,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (numB) => _numberB = numB,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  RxBlocBuilder<DivisionBlocType, bool>(
                    state: (bloc) => bloc.states.isLoading,
                    builder: (ctx, state, bloc) => OutlineButton(
                      child: Text((state?.data ?? false)
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
                          Text(state?.data ?? 'Enter numbers to divide.'),
                    ),
                  ),
                  RxBlocListener<DivisionBlocType, String>(
                    state: (bloc) => bloc.states.errors,
                    listener: (ctx, state) {
                      final error = state ?? '';
                      if (error.isNotEmpty)
                        Scaffold.of(ctx).showSnackBar(
                            SnackBar(content: Text("Error: $error")));
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
