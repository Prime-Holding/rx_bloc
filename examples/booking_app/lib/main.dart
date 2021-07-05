import 'package:booking_app/base/remote_data_sources/hotels_remote_data_source_factory.dart';
import 'package:booking_app/base/ui_components/firebase_initializer.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/feature_hotel/search/blocs/hotel_list_bloc.dart';

import 'base/common_blocs/coordinator_bloc.dart';
import 'base/repositories/hotels_repository.dart';
import 'base/repositories/paginated_hotels_repository.dart';
import 'feature_home/views/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => FirebaseInitializer(
        child: MultiProvider(
          providers: [
            Provider<PaginatedHotelsRepository>(
              create: (context) => PaginatedHotelsRepository(HotelsRepository(
                  hotelsDataSource: HotelsRemoteDataSourceFactory.fromInput(
                      const String.fromEnvironment('DATA_SOURCE')))),
            ),
            Provider<CoordinatorBlocType>(
                create: (context) => CoordinatorBloc()),
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
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
            ),
          ),
        ),
      );
}
