import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_blocs/hotel_manage_bloc.dart';
import '../../base/common_blocs/hotels_extra_details_bloc.dart';
import '../../feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import '../blocs/navigation_bar_bloc.dart';
import '../views/home_page.dart';

class HomePageWithDependencies extends StatelessWidget {
  const HomePageWithDependencies({
    required this.navigationType,
    super.key,
  });

  final NavigationItemType navigationType;
  static const String kHomePageKeyValue = 'HomePageKeyValue';

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<HotelFavoritesBlocType>(
          create: (context) => HotelFavoritesBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<HotelManageBlocType>(
          create: (context) => HotelManageBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<HotelsExtraDetailsBlocType>(
          create: (context) => HotelsExtraDetailsBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<NavigationBarBlocType>(
          create: (context) => NavigationBarBloc(
            navigationType,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        key: ValueKey(
          _DataKey(
            typeName: kHomePageKeyValue,
            navigationType: navigationType,
          ),
        ),
        child: const HomePage(),
      );
}

class _DataKey with EquatableMixin {
  _DataKey({
    required this.typeName,
    required this.navigationType,
  });

  final String typeName;
  final NavigationItemType navigationType;

  @override
  List<Object?> get props => [
        typeName,
        navigationType,
      ];
}
