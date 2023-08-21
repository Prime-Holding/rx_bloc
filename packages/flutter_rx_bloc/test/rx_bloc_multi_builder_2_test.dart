import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/src/rx_bloc_multi_builder_2.dart';
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
  group('StreamMultiBuilder2', () {
    testWidgets('gracefully handles transition from null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        builder: snapshotText,
        stream1: null,
        stream2: null,
      ));
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, null, null, null)'),
          findsNWidgets(2));
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(2));
    });
    testWidgets('gracefully handles transition to null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(2));
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        builder: snapshotText,
        stream1: null,
        stream2: null,
      ));
      expect(
        find.text(
            'AsyncSnapshot<String>(ConnectionState.none, null, null, null)'),
        findsNWidgets(2),
      );
    });
    testWidgets('gracefully handles transition to other stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controllerA = StreamController<String>();
      final controllerB = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controllerA.stream,
        stream2: null,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsOneWidget);
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controllerB.stream,
        stream2: null,
        builder: snapshotText,
      ));
      controllerB.add('B');
      controllerA.add('A');
      await eventFiring(tester);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.active, B, null, null)'),
          findsOneWidget);
    });
    testWidgets('tracks events and errors of stream until completion',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(2));
      controller1
        ..add('1-1')
        ..add('2-1');
      controller2
        ..add('1-2')
        ..add('2-2');
      await eventFiring(tester);
      expect(
        find.text(
            'AsyncSnapshot<String>(ConnectionState.active, 2-1, null, null)'),
        findsOneWidget,
      );
      expect(
        find.text(
            'AsyncSnapshot<String>(ConnectionState.active, 2-2, null, null)'),
        findsOneWidget,
      );
      controller1
        ..add('3-1')
        ..addError('bad', StackTrace.fromString('trace'));
      controller2
        ..add('3-2')
        ..addError('bad', StackTrace.fromString('trace'));
      await eventFiring(tester);
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.active, null, bad, trace)',
          ),
          findsNWidgets(2));
      controller1.add('4-1');
      controller2.add('4-2');
      unawaited(controller1.close());
      unawaited(controller2.close());
      await eventFiring(tester);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.done, 4-1, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.done, 4-2, null, null)'),
          findsOneWidget);
    });
    testWidgets('runs the builder using given initial data',
        (WidgetTester tester) async {
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        stream1: controller1.stream,
        stream2: controller2.stream,
        builder: snapshotText,
        initialData1: 'I-1',
        initialData2: 'I-2',
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, I-1, null, null)',
          ),
          findsOneWidget);
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, I-2, null, null)',
          ),
          findsOneWidget);
    });
    testWidgets('ignores initialData when reconfiguring',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: null,
        stream2: null,
        builder: snapshotText,
        initialData1: 'I-1',
        initialData2: 'I-2',
      ));
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, I-1, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, I-2, null, null)'),
          findsOneWidget);
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder2<String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        builder: snapshotText,
        initialData1: 'Ignored-1',
        initialData2: 'Ignored-2',
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, I-1, null, null)',
          ),
          findsOneWidget);
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, I-2, null, null)',
          ),
          findsOneWidget);
    });
  });
  group('StreamMultiBuilderBase2', () {
    testWidgets('gracefully handles transition from null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StringCollector(key: key));
      expect(find.text(''), findsNWidgets(2));
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
      ));
      expect(find.text('conn-1'), findsOneWidget);
      expect(find.text('conn-2'), findsOneWidget);
    });
    testWidgets('gracefully handles transition to null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
      ));
      expect(find.text('conn-1'), findsOneWidget);
      expect(find.text('conn-2'), findsOneWidget);
      await tester.pumpWidget(StringCollector(key: key));
      expect(find.text('conn-1, disc-1'), findsOneWidget);
      expect(find.text('conn-2, disc-2'), findsOneWidget);
    });
    testWidgets('gracefully handles transition to other stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controllerA = StreamController<String>();
      final controllerB = StreamController<String>();
      await tester
          .pumpWidget(StringCollector(key: key, stream1: controllerA.stream));
      await tester
          .pumpWidget(StringCollector(key: key, stream1: controllerB.stream));
      controllerA.add('A');
      controllerB.add('B');
      await eventFiring(tester);
      expect(find.text('conn-1, disc-1, conn-1, data-1:B'), findsOneWidget);
    });
    testWidgets('tracks events and errors until completion',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
      ));
      controller1
        ..add('1-1')
        ..addError('bad-1', StackTrace.fromString('trace-1'))
        ..add('2-1');
      controller2
        ..add('1-2')
        ..addError('bad-2', StackTrace.fromString('trace-2'))
        ..add('2-2');
      unawaited(controller1.close());
      unawaited(controller2.close());
      await eventFiring(tester);
      expect(
        find.text(
          'conn-1, data-1:1-1, error-1:bad-1 '
          'stackTrace:trace-1, data-1:2-1, done-1',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'conn-2, data-2:1-2, error-2:bad-2 '
          'stackTrace:trace-2, data-2:2-2, done-2',
        ),
        findsOneWidget,
      );
    });
  });
}

Future<void> eventFiring(WidgetTester tester) async {
  await tester.pump(Duration.zero);
}

Widget snapshotText(
  BuildContext context,
  AsyncSnapshot<String> snapshot1,
  AsyncSnapshot<String> snapshot2,
) =>
    Column(
      children: [
        Text(snapshot1.toString(), textDirection: TextDirection.ltr),
        Text(snapshot2.toString(), textDirection: TextDirection.ltr),
      ],
    );

class StringCollector extends StreamMultiBuilderBase2<String, String,
    List<String>, List<String>> {
  const StringCollector({
    super.key,
    super.stream1,
    super.stream2,
  });

  @override
  List<String> initial1() => <String>[];

  @override
  List<String> initial2() => <String>[];

  @override
  List<String> afterConnected1(List<String> current) => current..add('conn-1');

  @override
  List<String> afterConnected2(List<String> current) => current..add('conn-2');

  @override
  List<String> afterData1(List<String> current, String data) =>
      current..add('data-1:$data');

  @override
  List<String> afterData2(List<String> current, String data) =>
      current..add('data-2:$data');

  @override
  List<String> afterError1(
          List<String> current, dynamic error, StackTrace stackTrace) =>
      current..add('error-1:$error stackTrace:$stackTrace');

  @override
  List<String> afterError2(
          List<String> current, dynamic error, StackTrace stackTrace) =>
      current..add('error-2:$error stackTrace:$stackTrace');

  @override
  List<String> afterDone1(List<String> current) => current..add('done-1');

  @override
  List<String> afterDone2(List<String> current) => current..add('done-2');

  @override
  List<String> afterDisconnected1(List<String> current) =>
      current..add('disc-1');

  @override
  List<String> afterDisconnected2(List<String> current) =>
      current..add('disc-2');

  @override
  Widget build(
    BuildContext context,
    List<String> currentSummary1,
    List<String> currentSummary2,
  ) =>
      Column(
        children: [
          Text(currentSummary1.join(', '), textDirection: TextDirection.ltr),
          Text(currentSummary2.join(', '), textDirection: TextDirection.ltr)
        ],
      );
}
