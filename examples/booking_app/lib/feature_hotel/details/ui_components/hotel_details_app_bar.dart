part of '../views/hotel_details_page.dart';

extension _HotelDetailsPageAppBar on _HotelDetailsPageState {
  List<Widget> _buildTrailingItems(BuildContext context, Hotel hotel) => [
        _buildFavouriteButton(context, hotel),
      ];

  Widget _buildFavouriteButton(BuildContext context, Hotel hotel) =>
      hotel.isFavorite
          ? IconButton(
              icon: IconWithShadow(
                  icon: Icons.favorite,
                  iconColor: DesignSystem.of(context).colors.tertiaryIconColor),
              onPressed: () => _markAsFavorite(context, false, hotel),
            )
          : IconButton(
              icon: IconWithShadow(
                  icon: Icons.favorite_border,
                  iconColor: DesignSystem.of(context).colors.tertiaryIconColor),
              onPressed: () => _markAsFavorite(context, true, hotel),
            );

  void _markAsFavorite(BuildContext context, bool isFavorite, Hotel hotel) =>
      RxBlocProvider.of<HotelManageBlocType>(context)
          .events
          .markAsFavorite(hotel: hotel, isFavorite: isFavorite);
}
