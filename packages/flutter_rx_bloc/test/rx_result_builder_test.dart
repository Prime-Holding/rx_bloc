import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'counter/blocs/counter_bloc.dart';
import 'counter/views/counter_result_widget.dart';

void main() {
  group('BlocResultBuilder', () {
    testWidgets('Build with lookup', (tester) async {
      final bloc = CounterBloc(initialState: Result<int>.loading());

      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<CounterBlocType>(
            create: (ctx) => bloc,
            child: const CounterResultWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester
            .widgetList<Container>(
              find.byKey(const Key(CounterResultWidget.loadingKey)),
            )
            .length,
        1,
      );

      bloc.setCount(1);

      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(
              find.byKey(const Key(CounterResultWidget.countKey)),
            )
            .data,
        '1',
      );

      bloc.setError(Exception('error'));

      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(
              find.byKey(const Key(CounterResultWidget.errorKey)),
            )
            .data,
        'Exception: error',
      );
    });
  });
}
