import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/src/models/entity.dart';

// ignore: must_be_immutable
class Hotel extends Equatable implements Entity {
  final String id;
  final String imagePath;
  final String title;
  final String subTitle;
  final int perNight;
  final double dist;
  final double rating;
  final int reviews;
  final String description;
  final List<String> features;
  final int roomCapacity;
  final int personCapacity;
  final DateTime startWorkDate;
  final DateTime endWorkDate;
  bool isFavorite;

  // Properties that should simulate remote fetching of entity data
  final List<String>? displayFeatures;
  final String? displayDescription;
  final String? displaySubtitle;
  final int? displayReviews;
  final double? displayRating;
  final double? displayDist;

  Hotel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.perNight,
    required this.dist,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.features,
    required this.roomCapacity,
    required this.personCapacity,
    required this.startWorkDate,
    required this.endWorkDate,
    required this.description,
    this.displaySubtitle,
    this.displayReviews,
    this.displayRating,
    this.displayDist,
    this.displayDescription,
    this.displayFeatures,
  });

  Hotel copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? subTitle,
    int? perNight,
    double? dist,
    double? rating,
    int? reviews,
    String? description,
    List<String>? features,
    int? roomCapacity,
    int? personCapacity,
    DateTime? startWorkDate,
    DateTime? endWorkDate,
    bool? isFavorite,
    String? displaySubtitle,
    int? displayReviews,
    double? displayRating,
    double? displayDist,
    String? displayDescription,
    List<String>? displayFeatures,
  }) =>
      Hotel(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        perNight: perNight ?? this.perNight,
        dist: dist ?? this.dist,
        rating: rating ?? this.rating,
        reviews: reviews ?? this.reviews,
        isFavorite: isFavorite ?? this.isFavorite,
        description: description ?? this.description,
        features: features ?? this.features,
        roomCapacity: roomCapacity ?? this.roomCapacity,
        personCapacity: personCapacity ?? this.personCapacity,
        startWorkDate: startWorkDate ?? this.startWorkDate,
        endWorkDate: endWorkDate ?? this.endWorkDate,
        displaySubtitle: displaySubtitle ?? this.displaySubtitle,
        displayReviews: displayReviews ?? this.displayReviews,
        displayRating: displayRating ?? this.displayRating,
        displayDist: displayDist ?? this.displayDist,
        displayDescription: displayDescription ?? this.displayDescription,
        displayFeatures: displayFeatures ?? this.displayFeatures,
      );

  Hotel copyWithHotel(Hotel hotel) => Hotel(
        id: hotel.id,
        imagePath: hotel.imagePath,
        title: hotel.title,
        subTitle: hotel.subTitle,
        perNight: hotel.perNight,
        dist: hotel.dist,
        rating: hotel.rating,
        reviews: hotel.reviews,
        isFavorite: hotel.isFavorite,
        features: hotel.features,
        description: hotel.description,
        roomCapacity: hotel.roomCapacity,
        personCapacity: hotel.personCapacity,
        startWorkDate: hotel.startWorkDate,
        endWorkDate: hotel.endWorkDate,
        displaySubtitle: hotel.displaySubtitle ?? displaySubtitle,
        displayReviews: hotel.displayReviews ?? displayReviews,
        displayRating: hotel.displayRating ?? displayRating,
        displayDist: hotel.displayDist ?? displayDist,
        displayFeatures: hotel.displayFeatures ?? displayFeatures,
        displayDescription: hotel.displayDescription ?? displayDescription,
      );

  @override
  T copyWithEntity<T extends Entity>(T entity) =>
      copyWithHotel(entity as Hotel) as T;

  @override
  bool hasExtraDetails() =>
      displayRating != null &&
      displayReviews != null &&
      displaySubtitle != null &&
      displayDist != null;

  bool hasFullExtraDetails() =>
      displayDescription != null && displayFeatures != null;

  @override
  List<Object?> get props => [
        id,
        imagePath,
        title,
        subTitle,
        perNight,
        dist,
        rating,
        reviews,
        // description,
        features,
        roomCapacity,
        personCapacity,
        endWorkDate,
        isFavorite
      ];
}
