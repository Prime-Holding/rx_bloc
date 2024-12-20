import 'package:booking_app/base/common_blocs/hotel_manage_bloc.dart';
import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart';
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/views/hotel_search_page.dart';
import 'package:booking_app/lib_router/blocs/router_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../feature_home/mock/hotel_manage_mock.dart';
import '../../stubs.dart';
import '../mock/hotel_search_mock.dart';
import '../mock/hotels_extra_details_mock.dart';
import '../mock/router_bloc_mock.dart';

void main() {
  group('HotelSearchPage', () {
    final mockExtraDetailsBloc = hotelsExtraDetailsMockFactory();
    final mockHotelManageBloc = hotelManageMockFactory();

    testWidgets('Hotel sorting option opens/closes', (tester) async {
      final mockRouterBloc = routerMockFactory();
      final mockHotelSearchBloc = hotelSearchMockFactory(
        hotels: Stub.paginatedListTwoHotels,
        capacityFilterData: CapacityFilterData(
          rooms: 1,
          persons: 2,
          text: '1 room, 2 persons',
        ),
      );
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<HotelSearchBlocType>.value(value: mockHotelSearchBloc),
          Provider<RouterBlocType>.value(value: mockRouterBloc),
          Provider<HotelsExtraDetailsBlocType>.value(
              value: mockExtraDetailsBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: HotelSearchPage()),
        ),
      ));

      // Tap on sort button to open sorting options
      await tester.tap(find.byKey(keys.sortFilterTapKey));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Sort hotels by'), findsOne);

      // Tap on apply button to close sorting options
      await tester.tap(find.byKey(keys.sortFilterApplyTapKey));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Sort hotels by'), findsNothing);
    });

    testWidgets('Hotel list error widget displayed (with reloading)',
        (tester) async {
      final mockRouterBloc = routerMockFactory();
      final hotelSearchBlocMock = hotelSearchMockFactory(
        hotels: Stub.paginatedListError,
      );
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<HotelSearchBlocType>.value(value: hotelSearchBlocMock),
          Provider<RouterBlocType>.value(value: mockRouterBloc),
          Provider<HotelsExtraDetailsBlocType>.value(
              value: mockExtraDetailsBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: HotelSearchPage()),
        ),
      ));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(keys.errorRetryWidgetKey), findsOneWidget);

      await tester.tap(find.byKey(keys.errorRetryTapKey));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(keys.errorRetryWidgetKey), findsOneWidget);
    });

    testWidgets(
        'Execute hotel callback after pressing on hotel and favorite button',
        (tester) async {
      var opened = false;
      final mockRouterBloc = routerMockFactory(
        onPushTo: () {
          opened = true;
        },
      );
      final hotelSearchBlocMock = hotelSearchMockFactory(
        hotels: Stub.paginatedListOneHotel,
      );
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<HotelSearchBlocType>.value(value: hotelSearchBlocMock),
          Provider<RouterBlocType>.value(value: mockRouterBloc),
          Provider<HotelsExtraDetailsBlocType>.value(
              value: mockExtraDetailsBloc),
          Provider<HotelManageBlocType>.value(value: mockHotelManageBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: HotelSearchPage()),
        ),
      ));
      await tester.pump(const Duration(seconds: 1));
      expect(opened, false);

      await tester.tap(find.byKey(keys.favoriteButtonById(Stub.hotel1.id)));

      await tester.tap(
        find.byKey(keys.listItemTapById(Stub.hotel1.id)),
      );
      expect(opened, true);
    });
  });

  group('HotelSearchPage', () {
    testWidgets('should display search results and handle hotel press',
        (WidgetTester tester) async {
      final key = keys.listItemTapById(Stub.hotel1.id);
      bool called = false;
      final mockHotelSearchBloc = hotelSearchMockFactory(
        hotels: Stub.paginatedListOneHotel,
        hotelsFound: '1 hotel found',
        sortedBy: SortBy.priceAsc,
      );
      final mockExtraDetailsBloc = hotelsExtraDetailsMockFactory();
      final mockRouterBloc = routerMockFactory(
        onPushTo: () {
          called = true;
        },
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<HotelSearchBlocType>.value(value: mockHotelSearchBloc),
            Provider<RouterBlocType>.value(value: mockRouterBloc),
            Provider<HotelsExtraDetailsBlocType>.value(
                value: mockExtraDetailsBloc),
          ],
          child: const MaterialApp(
            home: Scaffold(body: HotelSearchPage()),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(called, false);
      expect(find.byKey(key), findsOne);
      await tester.tap(find.byKey(key));
      expect(called, true);
    });
  });
}
