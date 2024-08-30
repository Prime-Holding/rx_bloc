import 'package:booking_app/feature_hotel_search/ui_components/hotel_sort_page.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_sort_page'),
      widget: const HotelSortPage(), //example: Stubs.emptyList
    ),
  ]);

  group('HotelSortPage', () {
    const initialSelection = SortBy.priceAsc;

    testWidgets(
        'should call onApplyPressed with correct value when Apply button is pressed',
        (WidgetTester tester) async {
      SortBy appliedSortBy = SortBy.none;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelSortPage(
              initialSelection: initialSelection,
              onApplyPressed: (sortBy) {
                appliedSortBy = sortBy;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DialogButton));
      await tester.pumpAndSettle();

      expect(appliedSortBy, initialSelection);
    });

    testWidgets('should update selected sort option when a sort item is tapped',
        (WidgetTester tester) async {
      const textToFind = 'first';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelSortPage(
              initialSelection: initialSelection,
              onApplyPressed: (sortBy) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text(textToFind).first);
      await tester.pumpAndSettle();

      expect(find.text(textToFind).first, findsOneWidget);
    });
  });
}
