import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:booking_app/base/ui_components/icon_with_shadow.dart';
import 'package:booking_app/feature_hotel/blocs/hotel_manage_bloc.dart';

class HotelDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const HotelDetailsAppBar({
    required Hotel hotel,
    Key? key,
  })  : _hotel = hotel,
        super(key: key);

  final Hotel _hotel;

  @override
  Widget build(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const IconWithShadow(icon: Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        actions: _buildTrailingItems(context),
        elevation: 0,
      );

  List<Widget> _buildTrailingItems(BuildContext context) => [
        _buildFavouriteButton(context),
      ];

  Widget _buildFavouriteButton(BuildContext context) => _hotel.isFavorite
      ? IconButton(
          icon: const IconWithShadow(icon: Icons.favorite),
          onPressed: () => _markAsFavorite(context, false),
        )
      : IconButton(
          icon: const IconWithShadow(icon: Icons.favorite_border),
          onPressed: () => _markAsFavorite(context, true),
        );

  void _markAsFavorite(BuildContext context, bool isFavorite) =>
      RxBlocProvider.of<HotelManageBlocType>(context)
          .events
          .markAsFavorite(hotel: _hotel, isFavorite: isFavorite);

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
