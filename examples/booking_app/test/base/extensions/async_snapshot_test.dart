import 'package:booking_app/base/extensions/async_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('build method returns builder widget when hasData is true',
      (WidgetTester tester) async {
    const snapshot = AsyncSnapshot.withData(ConnectionState.done, 'Test Data');
    final widget =
        snapshot.build((data) => Text(data), fallback: const Text('Fallback'));

    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.text('Test Data'), findsOneWidget);
    expect(find.text('Fallback'), findsNothing);
  });

  testWidgets(
      'build method returns fallback widget when hasData is false and fallback is provided',
      (WidgetTester tester) async {
    const snapshot = AsyncSnapshot<String>.nothing();
    final widget =
        snapshot.build((data) => Text(data), fallback: const Text('Fallback'));

    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.text('Fallback'), findsOneWidget);
    expect(find.text('Test Data'), findsNothing);
  });

  testWidgets(
      'build method returns empty Container when hasData is false and fallback is not provided',
      (WidgetTester tester) async {
    const snapshot = AsyncSnapshot<String>.nothing();
    final widget = snapshot.build((data) => Text(data));

    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byType(Container), findsOneWidget);
    expect(find.text('Test Data'), findsNothing);
    expect(find.text('Fallback'), findsNothing);
  });
}
