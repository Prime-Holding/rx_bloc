import 'package:booking_app/feature_hotel/search/blocs/hotel_list_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base/common_blocs/coordinator_bloc.dart';
import 'base/repositories/paginated_hotels_repository.dart';
import 'feature_home/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PaginatedHotelsRepository>(
            create: (context) => PaginatedHotelsRepository(
              HotelsRepository(
                ConnectivityRepository(),
                multiplier: 100,
              ),
            ),
          ),
          Provider<CoordinatorBlocType>(create: (context) => CoordinatorBloc()),
          Provider<HotelListBlocType>(
            create: (context) => HotelListBloc(
              Provider.of(context, listen: false),
              Provider.of(context, listen: false),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Booking app',
          home: HomePage.page(),
          theme: DesignSystemOptions.build(context, Brightness.light).theme,
          darkTheme: DesignSystemOptions.build(context, Brightness.dark).theme,
        ),
      );
}
