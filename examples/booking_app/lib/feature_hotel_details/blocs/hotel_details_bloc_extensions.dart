part of 'hotel_details_bloc.dart';

extension _OnHotelUpdated on CoordinatorBlocType {
  Stream<Hotel> onHotelUpdated(Hotel hotel) =>
      states.onHotelsUpdated.whereHotel(hotel);
}

extension _WhereHotelUpdated on Stream<List<Hotel>> {
  Stream<Hotel> whereHotel(Hotel hotel) => map<Hotel?>(
        (hotels) => hotels.firstWhereOrNull(
          (item) => item.id == hotel.id,
        ),
      ).whereType<Hotel>();
}

extension _ExtractHotelProperties on Stream<Hotel> {
  Stream<String> mapToTitle() => map((hotel) => hotel.title);

  Stream<String> mapToSubTitle() => map((hotel) => hotel.subTitle);

  Stream<String> mapToImagePath() => map((hotel) => hotel.imagePath);

  Stream<String> mapToRating() =>
      map((hotel) => hotel.displayRating.toString());

  Stream<bool> mapToIsFavorite() => map((hotel) => hotel.isFavorite);
}
