part of '../views/hotel_details_page.dart';

extension _HotelDetailsPageAppBar on HotelDetailsPage {
  List<Widget> _buildTrailingItems(BuildContext context, Hotel hotel) => [
        _buildFavouriteButton(context, hotel),
      ];

  Widget _buildFavouriteButton(BuildContext context, Hotel hotel) => IconButton(
        key: keys.detailsFavoriteButtonById(hotel.id),
        icon: IconWithShadow(
            icon: hotel.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () => RxBlocProvider.of<HotelManageBlocType>(context)
            .events
            .markAsFavorite(hotel: hotel, isFavorite: !hotel.isFavorite),
      );
}
