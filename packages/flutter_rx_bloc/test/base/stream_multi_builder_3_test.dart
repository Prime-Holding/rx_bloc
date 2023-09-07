import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/src/base/stream_multi_builder_3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreamMultiBuilder3 Tests', () {
    testWidgets('gracefully handles transition from null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        builder: snapshotText,
        stream1: null,
        stream2: null,
        stream3: null,
      ));
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, null, null, null)'),
          findsNWidgets(3));
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(3));
    });
    testWidgets('gracefully handles transition to null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(3));
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        builder: snapshotText,
        stream1: null,
        stream2: null,
        stream3: null,
      ));
      expect(
        find.text(
            'AsyncSnapshot<String>(ConnectionState.none, null, null, null)'),
        findsNWidgets(3),
      );
    });
    testWidgets('gracefully handles transition to other stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controllerA = StreamController<String>();
      final controllerB = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controllerA.stream,
        stream2: null,
        stream3: null,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsOneWidget);
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controllerB.stream,
        stream2: null,
        stream3: null,
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
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
        builder: snapshotText,
      ));
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, null, null, null)',
          ),
          findsNWidgets(3));
      controller1
        ..add('1-1')
        ..add('2-1');
      controller2
        ..add('1-2')
        ..add('2-2');
      controller3
        ..add('1-3')
        ..add('2-3');
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
      expect(
        find.text(
            'AsyncSnapshot<String>(ConnectionState.active, 2-3, null, null)'),
        findsOneWidget,
      );
      controller1
        ..add('3-1')
        ..addError('bad', StackTrace.fromString('trace'));
      controller2
        ..add('3-2')
        ..addError('bad', StackTrace.fromString('trace'));
      controller3
        ..add('3-3')
        ..addError('bad', StackTrace.fromString('trace'));
      await eventFiring(tester);
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.active, null, bad, trace)',
          ),
          findsNWidgets(3));
      controller1.add('4-1');
      controller2.add('4-2');
      controller3.add('4-3');
      unawaited(controller1.close());
      unawaited(controller2.close());
      unawaited(controller3.close());
      await eventFiring(tester);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.done, 4-1, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.done, 4-2, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.done, 4-3, null, null)'),
          findsOneWidget);
    });
    testWidgets('runs the builder using given initial data',
        (WidgetTester tester) async {
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
        builder: snapshotText,
        initialData1: 'I-1',
        initialData2: 'I-2',
        initialData3: 'I-3',
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
      expect(
          find.text(
            'AsyncSnapshot<String>(ConnectionState.waiting, I-3, null, null)',
          ),
          findsOneWidget);
    });
    testWidgets('ignores initialData when reconfiguring',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: null,
        stream2: null,
        stream3: null,
        builder: snapshotText,
        initialData1: 'I-1',
        initialData2: 'I-2',
        initialData3: 'I-3',
      ));
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, I-1, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, I-2, null, null)'),
          findsOneWidget);
      expect(
          find.text(
              'AsyncSnapshot<String>(ConnectionState.none, I-3, null, null)'),
          findsOneWidget);
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StreamMultiBuilder3<String, String, String>(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
        builder: snapshotText,
        initialData1: 'Ignored-1',
        initialData2: 'Ignored-2',
        initialData3: 'Ignored-2',
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
  group('StreamMultiBuilderBase3 Tests', () {
    testWidgets('gracefully handles transition from null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(StringCollector(key: key));
      expect(find.text(''), findsNWidgets(3));
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
      ));
      expect(find.text('conn-1'), findsOneWidget);
      expect(find.text('conn-2'), findsOneWidget);
      expect(find.text('conn-3'), findsOneWidget);
    });
    testWidgets('gracefully handles transition to null stream',
        (WidgetTester tester) async {
      final key = GlobalKey();
      final controller1 = StreamController<String>();
      final controller2 = StreamController<String>();
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
      ));
      expect(find.text('conn-1'), findsOneWidget);
      expect(find.text('conn-2'), findsOneWidget);
      expect(find.text('conn-3'), findsOneWidget);
      await tester.pumpWidget(StringCollector(key: key));
      expect(find.text('conn-1, disc-1'), findsOneWidget);
      expect(find.text('conn-2, disc-2'), findsOneWidget);
      expect(find.text('conn-3, disc-3'), findsOneWidget);
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
      final controller3 = StreamController<String>();
      await tester.pumpWidget(StringCollector(
        key: key,
        stream1: controller1.stream,
        stream2: controller2.stream,
        stream3: controller3.stream,
      ));
      controller1
        ..add('1-1')
        ..addError('bad-1', StackTrace.fromString('trace-1'))
        ..add('2-1');
      controller2
        ..add('1-2')
        ..addError('bad-2', StackTrace.fromString('trace-2'))
        ..add('2-2');
      controller3
        ..add('1-3')
        ..addError('bad-3', StackTrace.fromString('trace-3'))
        ..add('2-3');
      unawaited(controller1.close());
      unawaited(controller2.close());
      unawaited(controller3.close());
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
      expect(
        find.text(
          'conn-3, data-3:1-3, error-3:bad-3 '
          'stackTrace:trace-3, data-3:2-3, done-3',
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
  AsyncSnapshot<String> snapshot3,
) =>
    Column(
      children: [
        Text(snapshot1.toString(), textDirection: TextDirection.ltr),
        Text(snapshot2.toString(), textDirection: TextDirection.ltr),
        Text(snapshot3.toString(), textDirection: TextDirection.ltr),
      ],
    );

class StringStreamContainer extends StreamContainerBase<String, List<String>> {
  StringStreamContainer({required this.suffix, required super.stream});

  final String suffix;

  @override
  List<String> initial() => <String>[];

  @override
  List<String> afterConnected(List<String> current) =>
      current..add('conn-$suffix');

  @override
  List<String> afterData(List<String> current, String data) =>
      current..add('data-$suffix:$data');

  @override
  List<String> afterError(
          List<String> current, dynamic error, StackTrace stackTrace) =>
      current..add('error-$suffix:$error stackTrace:$stackTrace');

  @override
  List<String> afterDone(List<String> current) => current..add('done-$suffix');

  @override
  List<String> afterDisconnected(List<String> current) =>
      current..add('disc-$suffix');
}

class StringCollector extends StreamMultiBuilderBase3<String, String, String,
    List<String>, List<String>, List<String>> {
  StringCollector({
    super.key,
    Stream<String>? stream1,
    Stream<String>? stream2,
    Stream<String>? stream3,
  }) : super(
          streamContainer1: StringStreamContainer(suffix: '1', stream: stream1),
          streamContainer2: StringStreamContainer(suffix: '2', stream: stream2),
          streamContainer3: StringStreamContainer(suffix: '3', stream: stream3),
        );

  @override
  Widget build(
    BuildContext context,
    List<String> currentSummary1,
    List<String> currentSummary2,
    List<String> currentSummary3,
  ) =>
      Column(
        children: [
          Text(currentSummary1.join(', '), textDirection: TextDirection.ltr),
          Text(currentSummary2.join(', '), textDirection: TextDirection.ltr),
          Text(currentSummary3.join(', '), textDirection: TextDirection.ltr),
        ],
      );
}
