import 'package:booking_app/feature_hotel_search/ui_components/hotel_capacity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_capacity_page'),
      widget: HotelCapacityPage(
          onApplyPressed: (i1, i2) {}), //example: Stubs.emptyList
    ),
  ]);

  group('HotelCapacityPage', () {
    const initialRoomCapacity = 2;
    const initialPersonCapacity = 4;

    testWidgets('should display initial room and person capacities',
        (WidgetTester tester) async {
      const roomCapacityText = 'Room capacity';
      const personCountText = 'Person count';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCapacityPage(
              roomCapacity: initialRoomCapacity,
              personCapacity: initialPersonCapacity,
              onApplyPressed: (roomCapacity, personCapacity) {},
            ),
          ),
        ),
      );

      expect(find.text(roomCapacityText), findsOneWidget);
      expect(find.text('$initialRoomCapacity'), findsOneWidget);
      expect(find.text(personCountText), findsOneWidget);
      expect(find.text('$initialPersonCapacity'), findsOneWidget);
    });

    testWidgets(
        'should call onApplyPressed with correct values when Apply button is pressed',
        (WidgetTester tester) async {
      int appliedRoomCapacity = 0;
      int appliedPersonCapacity = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCapacityPage(
              roomCapacity: initialRoomCapacity,
              personCapacity: initialPersonCapacity,
              onApplyPressed: (roomCapacity, personCapacity) {
                appliedRoomCapacity = roomCapacity;
                appliedPersonCapacity = personCapacity;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DialogButton));
      await tester.pumpAndSettle();

      expect(appliedRoomCapacity, initialRoomCapacity);
      expect(appliedPersonCapacity, initialPersonCapacity);
    });

    testWidgets('should update room capacity when ItemValueChooser is changed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCapacityPage(
              roomCapacity: initialRoomCapacity,
              personCapacity: initialPersonCapacity,
              onApplyPressed: (roomCapacity, personCapacity) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.text('${initialRoomCapacity + 1}'), findsOneWidget);
    });

    testWidgets(
        'should update person capacity when ItemValueChooser is changed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCapacityPage(
              roomCapacity: initialRoomCapacity,
              personCapacity: initialPersonCapacity,
              onApplyPressed: (roomCapacity, personCapacity) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add).last);
      await tester.pumpAndSettle();

      expect(find.text('${initialPersonCapacity + 1}'), findsOneWidget);
    });
  });
}
