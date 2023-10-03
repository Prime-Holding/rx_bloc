import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../feature_hotel_search/blocs/hotel_search_bloc.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/hotels_extra_details_bloc.dart';
import '../repositories/paginated_hotels_repository.dart';
import '../services/hotels_service.dart';
import 'config/environment_config.dart';

/// This widget is the root of your application.
class MyApp extends StatefulWidget {
  const MyApp({
    required this.config,
    super.key,
  });

  final EnvironmentConfig config;

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyAppState extends State<MyApp> {
  late GoRouter goRouter;

  @override
  void initState() {
    goRouter = AppRouter().router;

    super.initState();
  }

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
          Provider<HotelsService>(
            create: (context) => HotelsService(
              context.read(),
            ),
          ),
          Provider<CoordinatorBlocType>(
            create: (context) => CoordinatorBloc(),
          ),
          Provider<HotelsExtraDetailsBlocType>(
            create: (context) => HotelsExtraDetailsBloc(
              context.read(),
              context.read(),
            ),
          ),
          Provider<HotelSearchBlocType>(
            create: (context) => HotelSearchBloc(
              Provider.of(context, listen: false),
              Provider.of(context, listen: false),
            ),
          ),
          Provider<RouterBlocType>(
            create: (context) => RouterBloc(router: goRouter),
          ),
        ],
        child: MaterialApp.router(
          title: 'Booking app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
          ),
          routerConfig: goRouter,
        ),
      );
}
