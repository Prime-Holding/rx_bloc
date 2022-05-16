part of '../views/hotel_details_page.dart';

extension _HotelDetailsPageAppBar on HotelDetailsPageState {
  List<Widget> _buildTrailingItems(BuildContext context, Hotel hotel) => [
        _buildFavouriteButton(context, hotel),
      ];

  Widget _buildFavouriteButton(BuildContext context, Hotel hotel) =>
      hotel.isFavorite
          ? IconButton(
              icon: const IconWithShadow(icon: Icons.favorite),
              onPressed: () => _markAsFavorite(context, false, hotel),
            )
          : IconButton(
              icon: const IconWithShadow(icon: Icons.favorite_border),
              onPressed: () => _markAsFavorite(context, true, hotel),
            );

  void _markAsFavorite(BuildContext context, bool isFavorite, Hotel hotel) =>
      RxBlocProvider.of<HotelManageBlocType>(context)
          .events
          .markAsFavorite(hotel: hotel, isFavorite: isFavorite);
}
