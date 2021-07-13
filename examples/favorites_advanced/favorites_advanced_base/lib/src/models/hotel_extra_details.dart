import 'package:equatable/equatable.dart';

class HotelExtraDetails extends Equatable {
  HotelExtraDetails({
    required this.id,
    required this.hotelId,
    required this.subTitle,
    required this.reviews,
    required this.rating,
  });

  final String id;
  final String hotelId;
  final String subTitle;
  final int reviews;
  final double rating;

  @override
  List<Object?> get props => [
        id,
        hotelId,
        subTitle,
        reviews,
        rating,
      ];

  HotelExtraDetails copyWith({
    String? id,
    String? hotelId,
    String? subTitle,
    int? reviews,
    double? rating,
  }) =>
      HotelExtraDetails(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        subTitle: subTitle ?? this.subTitle,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
      );

  HotelExtraDetails.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          hotelId: json['hotelId'] as String,
          subTitle: json['subTitle'] as String,
          rating: json['rating'] as double,
          reviews: json['reviews'] as int,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'subTitle': subTitle,
      'rating': rating,
      'reviews': reviews,
    };
  }
}
