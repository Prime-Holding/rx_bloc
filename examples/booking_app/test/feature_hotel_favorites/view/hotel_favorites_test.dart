import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import 'package:booking_app/feature_hotel_favorites/views/hotel_favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../mock/hotel_favorites_mock.dart';

void main() {
  group('HotelFavoritesPage', () {
    testWidgets('Error retry widget', (tester) async {
      final mockHotelFavBloc = hotelFavoritesMockFactory(
        favoriteHotels: Result.error(Exception('Error')),
      );
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<HotelFavoritesBlocType>.value(value: mockHotelFavBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: HotelFavoritesPage()),
        ),
      ));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const Key('ErrorRetryWidget')), findsOneWidget);

      await tester.tap(find.byKey(const Key('reload_button')));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const Key('ErrorRetryWidget')), findsOneWidget);
    });
  });
}
