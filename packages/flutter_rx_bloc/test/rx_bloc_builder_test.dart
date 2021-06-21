import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocs/counter_bloc.dart';

const _countKey = 'count_key';
const _noCountKey = 'no_count_key';

Widget _buildBlocBuilder({CounterBlocType? bloc}) {
  return RxBlocBuilder<CounterBlocType, int>(
    state: (bloc) => bloc.states.count,
    bloc: bloc,
    builder: (context, snapshot, bloc) => snapshot.hasData
        ? Text(
            snapshot.data.toString(),
            key: const Key(_countKey),
          )
        : Container(
            key: const Key(_noCountKey),
          ),
  );
}

void main() {
  group('BlocBuilder', () {
    testWidgets('Build with lookup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RxBlocProvider<CounterBlocType>(
            create: (ctx) => CounterBloc(countEvents: [1, 2]),
            child: _buildBlocBuilder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key(_countKey))).data,
        '2',
      );
    });

    testWidgets('Build with direct instance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _buildBlocBuilder(
            bloc: CounterBloc(countEvents: [1, 2]),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key(_countKey))).data,
        '2',
      );
    });

    testWidgets('Snapshot has no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _buildBlocBuilder(
            bloc: CounterBloc(countEvents: []),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widgetList(find.byKey(const Key(_countKey))).length,
        0,
      );

      expect(
        tester.widgetList(find.byKey(const Key(_noCountKey))).length,
        1,
      );
    });
  });
}
