import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/base/ui_components/favorite_message_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../feature_home/mock/hotel_manage_mock.dart';

void main() {
  group('favorite_message_listener tests', () {
    testWidgets('FavoriteMessageListener builds properly', (tester) async {
      final mockHotelManageBloc = hotelManageMockFactory(
        favoriteMessage: 'Favorite added',
      );

      await tester.pumpWidget(
        Provider<HotelManageBlocType>.value(
          value: mockHotelManageBloc,
          child: const MaterialApp(
            home: Scaffold(
              body: FavoriteMessageListener(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Favorite added'), findsOneWidget);
    });

    testWidgets('FavoriteMessageListener builds with SnackBar', (tester) async {
      final mockHotelManageBloc = hotelManageMockFactory(
        favoriteMessage: 'Favorite added',
      );

      await tester.pumpWidget(
        Provider<HotelManageBlocType>.value(
          value: mockHotelManageBloc,
          child: const MaterialApp(
            home: Scaffold(
              body: FavoriteMessageListener(overrideMargins: true),
            ),
          ),
        ),
      );

      await tester.pump();

      final snackBar = find.byType(SnackBar);
      expect(snackBar, findsOneWidget);
      final snackBarWidget = tester.widget<SnackBar>(snackBar);
      expect(snackBarWidget.margin,
          const EdgeInsets.only(bottom: 70, left: 12, right: 12));
    });
  });
}
