import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/src/rx_bloc_multi_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'counter/blocs/multi_builder_2_bloc.dart';

void main() {
  group('RxBlocMultiBuilder2', () {
    testWidgets('Build with lookup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<MultiBuilder2BlocType>(
            create: (ctx) => MultiBuilder2Bloc('IS-1', 'IS-2'),
            child: RxBlocMultiBuilder2<MultiBuilder2BlocType, String, String>(
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
            bloc: MultiBuilder2Bloc('IS-1', 'IS-2'),
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
            bloc: MultiBuilder2Bloc(),
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
}
