import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/src/models/entity.dart';
import 'package:favorites_advanced_base/src/models/hotel_extra_details.dart';
import 'package:favorites_advanced_base/src/models/hotel_full_extra_details.dart';

// ignore: must_be_immutable
class Hotel extends Equatable implements Entity {
  final String id;
  final String imagePath;
  final String title;
  final int perNight;
  final int roomCapacity;
  final int personCapacity;
  final DateTime startWorkDate;
  final DateTime endWorkDate;

  final HotelExtraDetails? extraDetails;
  final HotelFullExtraDetails? fullExtraDetails;

  bool isFavorite;

  Hotel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.perNight,
    required this.isFavorite,
    required this.roomCapacity,
    required this.personCapacity,
    required this.startWorkDate,
    required this.endWorkDate,
    this.extraDetails,
    this.fullExtraDetails,
  });

  Hotel copyWith({
    String? id,
    String? imagePath,
    String? title,
    int? perNight,
    int? roomCapacity,
    int? personCapacity,
    DateTime? startWorkDate,
    DateTime? endWorkDate,
    HotelExtraDetails? extraDetails,
    HotelFullExtraDetails? fullExtraDetails,
    bool? isFavorite,
  }) =>
      Hotel(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        title: title ?? this.title,
        perNight: perNight ?? this.perNight,
        isFavorite: isFavorite ?? this.isFavorite,
        roomCapacity: roomCapacity ?? this.roomCapacity,
        personCapacity: personCapacity ?? this.personCapacity,
        startWorkDate: startWorkDate ?? this.startWorkDate,
        endWorkDate: endWorkDate ?? this.endWorkDate,
        extraDetails: extraDetails ?? this.extraDetails,
        fullExtraDetails: fullExtraDetails ?? this.fullExtraDetails,
      );

  Hotel copyWithHotel(Hotel hotel) => Hotel(
        id: hotel.id,
        imagePath: hotel.imagePath,
        title: hotel.title,
        perNight: hotel.perNight,
        isFavorite: hotel.isFavorite,
        roomCapacity: hotel.roomCapacity,
        personCapacity: hotel.personCapacity,
        startWorkDate: hotel.startWorkDate,
        endWorkDate: hotel.endWorkDate,
        extraDetails: hotel.extraDetails,
        fullExtraDetails: hotel.fullExtraDetails,
      );

  int? get displayReviews => extraDetails?.reviews;
  double? get displayRating => extraDetails?.rating;
  double? get displayDist => extraDetails?.dist;
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
        imagePath,
        title,
        perNight,
        roomCapacity,
        personCapacity,
        endWorkDate,
        extraDetails,
        fullExtraDetails,
        isFavorite
      ];

  Hotel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          imagePath: json['imagePath'] as String,
          title: json['title'] as String,
          perNight: json['perNight'] as int,
          isFavorite: json['isFavorite'] as bool,
          roomCapacity: json['roomCapacity'] as int,
          personCapacity: json['personCapacity'] as int,
          startWorkDate: json['startWorkDate'].toDate() as DateTime,
          endWorkDate: json['startWorkDate'].toDate() as DateTime,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'perNight': perNight,
      'isFavorite': isFavorite,
      'roomCapacity': roomCapacity,
      'personCapacity': personCapacity,
      'startWorkDate': startWorkDate,
      'endWorkDate': endWorkDate,
    };
  }
}
