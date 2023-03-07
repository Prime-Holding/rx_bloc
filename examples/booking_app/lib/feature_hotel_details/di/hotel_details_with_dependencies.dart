import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_blocs/hotel_manage_bloc.dart';
import '../blocs/hotel_details_bloc.dart';
import '../views/hotel_details_page.dart';

class HotelDetailsWithDependencies extends StatelessWidget {
  const HotelDetailsWithDependencies({
    required this.hotelId,
    this.hotel,
    Key? key,
  }) : super(key: key);

  final String hotelId;
  final Hotel? hotel;

  static const kHotelDetailsPageKey = 'HotelDetailsPage';

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<HotelManageBlocType>(
          create: (context) => HotelManageBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<HotelDetailsBlocType>(
          create: (context) => HotelDetailsBloc(
            context.read(),
            context.read(),
            context.read(),
            hotelId: hotelId,
            hotel: hotel,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        key: ValueKey(_DataKey(
          page: kHotelDetailsPageKey,
          hotelId: hotelId,
          hotel: hotel,
        )),
        child: const HotelDetailsPage(),
      );
}

class _DataKey with EquatableMixin {
  _DataKey({
    required this.page,
    required this.hotelId,
    this.hotel,
  });

  final String page;
  final String hotelId;
  final Hotel? hotel;

  @override
  List<Object?> get props => [
        page,
        hotelId,
        hotel,
      ];
}
