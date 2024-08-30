import 'package:booking_app/base/ui_components/hotels_app_bar.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Extensions', () {
    test('NavigationItemType title', () {
      expect(NavigationItemType.search.asHotelTitle(), 'Book a hotel');
      expect(NavigationItemType.favorites.asHotelTitle(), 'Favorite hotels');
    });
  });
}
