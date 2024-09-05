import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'counter/blocs/counter_bloc.dart';
import 'counter/views/counter_result_widget.dart';
import 'mocks/bloc.dart';

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

  group('RxResultBuilder stream has error', () {
    late TestBloc mockBloc;
    late StreamController<Result<int>> streamController;

    setUp(() {
      mockBloc = TestBloc();
      streamController = StreamController<Result<int>>();
    });

    tearDown(() {
      streamController.close();
    });

    testWidgets('Error case', (tester) async {
      const errorMessage = 'Test error';

      await tester.pumpWidget(
        Provider<TestBloc>.value(
          value: mockBloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RxResultBuilder<TestBloc, int>(
              state: (_) => streamController.stream,
              buildSuccess: (context, data, bloc) => Text('Success: $data'),
              buildError: (context, error, bloc) => Text('Error: $error'),
              buildLoading: (context, bloc) =>
                  const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      await tester.pump();
      streamController.addError(Exception(errorMessage));
      await tester.pump();

      expect(find.text('Error: Exception: $errorMessage'), findsOneWidget);
    });
  });
}
