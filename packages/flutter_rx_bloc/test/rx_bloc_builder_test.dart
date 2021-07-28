import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'counter/blocs/counter_bloc.dart';
import 'counter/views/counter_widget.dart';

void main() {
  group('BlocBuilder', () {
    testWidgets('Build with lookup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<CounterBlocType>(
            create: (ctx) => CounterBloc(initialState: Result.success(2)),
            child: const CounterWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key(CounterWidget.countKey))).data,
        '2',
      );
    });

    testWidgets('Build with direct instance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(
            bloc: CounterBloc(initialState: Result.success(2)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key(CounterWidget.countKey))).data,
        '2',
      );
    });

    testWidgets('Snapshot has no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(
            bloc: CounterBloc(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widgetList(find.byKey(const Key(CounterWidget.countKey))).length,
        0,
      );

      expect(
        tester
            .widgetList(find.byKey(const Key(CounterWidget.noCountKey)))
            .length,
        1,
      );
    });
  });
}
