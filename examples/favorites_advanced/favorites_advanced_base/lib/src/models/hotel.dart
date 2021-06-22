import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/src/models/entity.dart';
import 'package:favorites_advanced_base/src/models/hotel_extra_details.dart';
import 'package:favorites_advanced_base/src/models/hotel_full_extra_details.dart';

// ignore: must_be_immutable
class Hotel extends Equatable implements Entity {
  final String id;
  final String image;
  final String title;
  final int perNight;
  final int roomCapacity;
  final int personCapacity;
  final DateTime workingDate;
  final double dist;

  final HotelExtraDetails? extraDetails;
  final HotelFullExtraDetails? fullExtraDetails;

  bool isFavorite;

  Hotel({
    required this.id,
    required this.image,
    required this.title,
    required this.perNight,
    required this.isFavorite,
    required this.roomCapacity,
    required this.personCapacity,
    required this.workingDate,
    required this.dist,
    this.extraDetails,
    this.fullExtraDetails,
  });

  Hotel copyWith({
    String? id,
    String? image,
    String? title,
    int? perNight,
    int? roomCapacity,
    int? personCapacity,
    DateTime? workingDate,
    double? dist,
    HotelExtraDetails? extraDetails,
    HotelFullExtraDetails? fullExtraDetails,
    bool? isFavorite,
  }) =>
      Hotel(
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        perNight: perNight ?? this.perNight,
        isFavorite: isFavorite ?? this.isFavorite,
        roomCapacity: roomCapacity ?? this.roomCapacity,
        personCapacity: personCapacity ?? this.personCapacity,
        workingDate: workingDate ?? this.workingDate,
        dist: dist ?? this.dist,
        extraDetails: extraDetails ?? this.extraDetails,
        fullExtraDetails: fullExtraDetails ?? this.fullExtraDetails,
      );

  Hotel copyWithHotel(Hotel hotel) => Hotel(
        id: hotel.id,
        image: hotel.image,
        title: hotel.title,
        perNight: hotel.perNight,
        isFavorite: hotel.isFavorite,
        roomCapacity: hotel.roomCapacity,
        personCapacity: hotel.personCapacity,
        workingDate: hotel.workingDate,
        dist: hotel.dist,
        extraDetails: hotel.extraDetails,
        fullExtraDetails: hotel.fullExtraDetails,
      );

  int? get displayReviews => extraDetails?.reviews;
  double? get displayRating => extraDetails?.rating;
  double? get displayDist => dist;
  String? get displaySubtitle => extraDetails?.subTitle;
  String? get displayDescription => fullExtraDetails?.description;
  List<String>? get displayFeatures => fullExtraDetails?.features;

  @override
  T copyWithEntity<T extends Entity>(T entity) =>
      copyWithHotel(entity as Hotel) as T;

  @override
  bool hasExtraDetails() => extraDetails != null;

  bool hasFullExtraDetails() => fullExtraDetails != null;

  @override
  List<Object?> get props => [
        id,
        image,
        title,
        perNight,
        roomCapacity,
        personCapacity,
        dist,
        workingDate,
        extraDetails,
        fullExtraDetails,
        isFavorite
      ];

  Hotel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          image: json['image'] as String,
          title: json['title'] as String,
          perNight: json['perNight'] as int,
          isFavorite: json['isFavorite'] as bool,
          roomCapacity: json['roomCapacity'] as int,
          personCapacity: json['personCapacity'] as int,
          workingDate: json['workingDate'].toDate() as DateTime,
          dist: json['dist'] as double,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'perNight': perNight,
      'isFavorite': isFavorite,
      'roomCapacity': roomCapacity,
      'personCapacity': personCapacity,
      'startWorkDate': workingDate,
      'workingDate': workingDate,
      'dist': dist,
    };
  }
}
