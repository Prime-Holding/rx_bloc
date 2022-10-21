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
