import 'package:booking_app/feature_hotel_search/ui_components/filter_value_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemValueChooser', () {
    testWidgets('should display initial value and title',
        (WidgetTester tester) async {
      const initialValue = 5;
      const title = 'Test Title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemValueChooser(
              initialValue: initialValue,
              onValueChanged: (int value) {},
              title: title,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text('$initialValue'), findsOneWidget);
    });

    testWidgets('should increment value when add button is pressed',
        (WidgetTester tester) async {
      const initialValue = 5;
      const title = 'Test Title';
      int changedValue = initialValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemValueChooser(
              initialValue: initialValue,
              onValueChanged: (int value) {
                changedValue = value;
              },
              title: title,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(changedValue, initialValue + 1);
      expect(find.text('${initialValue + 1}'), findsOneWidget);
    });

    testWidgets('should decrement value when remove button is pressed',
        (WidgetTester tester) async {
      const initialValue = 5;
      const title = 'Test Title';
      int changedValue = initialValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemValueChooser(
              initialValue: initialValue,
              onValueChanged: (int value) {
                changedValue = value;
              },
              title: title,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(changedValue, initialValue - 1);
      expect(find.text('${initialValue - 1}'), findsOneWidget);
    });

    testWidgets('should not decrement value below zero',
        (WidgetTester tester) async {
      const initialValue = 0;
      const title = 'Test Title';
      int changedValue = initialValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemValueChooser(
              initialValue: initialValue,
              onValueChanged: (int value) {
                changedValue = value;
              },
              title: title,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(changedValue, initialValue);
      expect(find.text('$initialValue'), findsOneWidget);
    });
  });
}
