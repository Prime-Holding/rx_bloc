part of 'hotel_details_bloc.dart';

extension _ExtractHotelProperties on Stream<Hotel> {
  Stream<String> mapToTitle() => map((hotel) => hotel.title);

  Stream<String> mapToSubTitle() =>
      map((hotel) => hotel.extraDetails!.subTitle);

  Stream<String> mapToImagePath() => map((hotel) => hotel.imagePath ?? '');

  Stream<String> mapToRating() =>
      map((hotel) => hotel.extraDetails!.rating.toString());

  Stream<bool> mapToIsFavorite() => map((hotel) => hotel.isFavorite);
}
