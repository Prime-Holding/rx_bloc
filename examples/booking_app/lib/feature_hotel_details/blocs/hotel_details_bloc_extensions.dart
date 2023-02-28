part of 'hotel_details_bloc.dart';

extension _OnHotelUpdated on CoordinatorBlocType {
  Stream<Hotel> onHotelUpdated(String hotelId) =>
      states.onHotelsUpdated.whereHotel(hotelId);
}

extension _WhereHotelUpdated on Stream<List<Hotel>> {
  Stream<Hotel> whereHotel(String hotelId) => map<Hotel?>(
        (hotels) => hotels.firstWhereOrNull(
          (item) => item.id == hotelId,
        ),
      ).whereType<Hotel>();
}
