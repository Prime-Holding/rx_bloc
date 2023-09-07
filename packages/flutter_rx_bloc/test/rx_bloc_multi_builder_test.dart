import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'multi_builder_test_bloc/multiple_states_bloc.dart';

void main() {
  group('RxBlocMultiBuilder2 Test', () {
    testWidgets('Build with lookup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<MultipleStatesBlocType>(
            create: (ctx) => MultipleStatesBloc('IS-1', 'IS-2'),
            child: RxBlocMultiBuilder2<MultipleStatesBlocType, String, String>(
              state1: (bloc) => bloc.states.state1,
              state2: (bloc) => bloc.states.state2,
              builder: (context, snapshot1, snapshot2, bloc) => Column(
                children: [
                  snapshot1.hasData
                      ? Text(snapshot1.requireData)
                      : const Text('-'),
                  snapshot2.hasData
                      ? Text(snapshot2.requireData)
                      : const Text('-'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('IS-1'), findsOneWidget);
      expect(find.text('IS-2'), findsOneWidget);
    });

    testWidgets('Build with direct instance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocMultiBuilder2(
            bloc: MultipleStatesBloc('IS-1', 'IS-2'),
            state1: (bloc) => bloc.states.state1,
            state2: (bloc) => bloc.states.state2,
            builder: (context, snapshot1, snapshot2, bloc) => Column(
              children: [
                snapshot1.hasData
                    ? Text(snapshot1.requireData)
                    : const Text('-'),
                snapshot2.hasData
                    ? Text(snapshot2.requireData)
                    : const Text('-'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('IS-1'), findsOneWidget);
      expect(find.text('IS-2'), findsOneWidget);
    });

    testWidgets('Snapshot has no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocMultiBuilder2(
            bloc: MultipleStatesBloc(),
            state1: (bloc) => bloc.states.state1,
            state2: (bloc) => bloc.states.state2,
            builder: (context, snapshot1, snapshot2, bloc) => Column(
              children: [
                snapshot1.hasData
                    ? Text(snapshot1.requireData)
                    : const Text('-'),
                snapshot2.hasData
                    ? Text(snapshot2.requireData)
                    : const Text('-'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('-'),
        findsNWidgets(2),
      );
    });
  });
  group('RxBlocMultiBuilder3 Test', () {
    testWidgets('Build with lookup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<MultipleStatesBlocType>(
            create: (ctx) => MultipleStatesBloc('IS-1', 'IS-2', 'IS-3'),
            child: RxBlocMultiBuilder3<MultipleStatesBlocType, String, String,
                String>(
              state1: (bloc) => bloc.states.state1,
              state2: (bloc) => bloc.states.state2,
              state3: (bloc) => bloc.states.state3,
              builder: (context, snapshot1, snapshot2, snapshot3, bloc) =>
                  Column(
                children: [
                  snapshot1.hasData
                      ? Text(snapshot1.requireData)
                      : const Text('-'),
                  snapshot2.hasData
                      ? Text(snapshot2.requireData)
                      : const Text('-'),
                  snapshot3.hasData
                      ? Text(snapshot3.requireData)
                      : const Text('-'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('IS-1'), findsOneWidget);
      expect(find.text('IS-2'), findsOneWidget);
      expect(find.text('IS-3'), findsOneWidget);
    });

    testWidgets('Build with direct instance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocMultiBuilder3(
            bloc: MultipleStatesBloc('IS-1', 'IS-2', 'IS-3'),
            state1: (bloc) => bloc.states.state1,
            state2: (bloc) => bloc.states.state2,
            state3: (bloc) => bloc.states.state3,
            builder: (context, snapshot1, snapshot2, snapshot3, bloc) => Column(
              children: [
                snapshot1.hasData
                    ? Text(snapshot1.requireData)
                    : const Text('-'),
                snapshot2.hasData
                    ? Text(snapshot2.requireData)
                    : const Text('-'),
                snapshot3.hasData
                    ? Text(snapshot3.requireData)
                    : const Text('-'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('IS-1'), findsOneWidget);
      expect(find.text('IS-2'), findsOneWidget);
    });

    testWidgets('Snapshot has no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocMultiBuilder3(
            bloc: MultipleStatesBloc(),
            state1: (bloc) => bloc.states.state1,
            state2: (bloc) => bloc.states.state2,
            state3: (bloc) => bloc.states.state3,
            builder: (context, snapshot1, snapshot2, snapshot3, bloc) => Column(
              children: [
                snapshot1.hasData
                    ? Text(snapshot1.requireData)
                    : const Text('-'),
                snapshot2.hasData
                    ? Text(snapshot2.requireData)
                    : const Text('-'),
                snapshot3.hasData
                    ? Text(snapshot3.requireData)
                    : const Text('-'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('-'),
        findsNWidgets(3),
      );
    });
  });
}
