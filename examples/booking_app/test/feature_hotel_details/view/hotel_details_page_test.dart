import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/feature_hotel_details/blocs/hotel_details_bloc.dart';
import 'package:booking_app/feature_hotel_details/views/hotel_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../stubs.dart';
import '../mock/hotel_details_mock.dart';
import '../mock/hotel_manage_mock.dart';

void main() {
  group('hotel_details_page tests', () {
    const favKey = ValueKey('favoriteButtonWithShadow');
    const displayDescription = 'Nice hotel';
    const displayFeatures = ['Free WiFi', 'Pool'];
    final mockHotel = Stub.hotel1.copyWith(
      displayDescription: displayDescription,
      displayFeatures: displayFeatures,
    );

    testWidgets('should display hotel details', (WidgetTester tester) async {
      final mockHotelDetailsBloc = hotelDetailsMockFactory(
        hotel: mockHotel,
      );
      final mockHotelManageBloc = hotelManageMockFactory();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<HotelDetailsBlocType>.value(value: mockHotelDetailsBloc),
            Provider<HotelManageBlocType>.value(value: mockHotelManageBloc),
          ],
          child: const MaterialApp(
            home: HotelDetailsPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text(displayDescription), findsOneWidget);
      for (var feature in displayFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
    });

    testWidgets('should mark hotel as favorite', (WidgetTester tester) async {
      var isFavorite = false;
      final hotel = mockHotel.copyWith(isFavorite: isFavorite);
      final mockHotelDetailsBloc = hotelDetailsMockFactory(
        hotel: hotel,
      );
      final mockHotelManageBloc = hotelManageMockFactory(
        markAsFavoriteCallback: () => isFavorite = true,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<HotelDetailsBlocType>.value(value: mockHotelDetailsBloc),
            Provider<HotelManageBlocType>.value(value: mockHotelManageBloc),
          ],
          child: const MaterialApp(
            home: HotelDetailsPage(),
          ),
        ),
      );

      await tester.pump();
      expect(isFavorite, false);
      await tester.tap(find.byKey(favKey));
      await tester.pump();
      expect(isFavorite, true);
    });

    testWidgets('should unmark hotel as favorite', (WidgetTester tester) async {
      var isFavorite = true;
      final hotel = mockHotel.copyWith(isFavorite: isFavorite);
      final mockHotelDetailsBloc = hotelDetailsMockFactory(
        hotel: hotel,
      );
      final mockHotelManageBloc = hotelManageMockFactory(
        markAsFavoriteCallback: () => isFavorite = false,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<HotelDetailsBlocType>.value(value: mockHotelDetailsBloc),
            Provider<HotelManageBlocType>.value(value: mockHotelManageBloc),
          ],
          child: const MaterialApp(
            home: HotelDetailsPage(),
          ),
        ),
      );

      await tester.pump();
      expect(isFavorite, true);
      await tester.tap(find.byKey(favKey));
      await tester.pump();
      expect(isFavorite, false);
    });
  });
}
