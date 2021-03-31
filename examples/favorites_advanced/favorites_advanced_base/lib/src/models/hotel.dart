import 'package:favorites_advanced_base/src/models/entity.dart';

class Hotel implements Entity {
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
  bool isFavorite;

  // Properties that should simulate remote fetching of entity data
  final String? displayFeatures;
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
    required String description,
    this.displaySubtitle,
    this.displayReviews,
    this.displayRating,
    this.displayDist,
    this.displayDescription,
    this.displayFeatures,
  }) : this.description = '$title $description';

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
    bool? isFavorite,
    String? displaySubtitle,
    int? displayReviews,
    double? displayRating,
    double? displayDist,
    String? displayDescription,
    String? displayFeatures,
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

  bool hasDetailsExtraDetails() =>
      displayDescription != null && displayFeatures != null;

  @override
  bool operator ==(Object other) {
    if (other is Hotel) {
      return id == other.id &&
          description == other.description &&
          features == other.features &&
          imagePath == other.imagePath &&
          title == other.title &&
          subTitle == other.subTitle &&
          perNight == other.perNight &&
          dist == other.dist &&
          rating == other.rating &&
          reviews == other.reviews &&
          displayDist == other.displayDist &&
          displayFeatures == other.displayFeatures &&
          displayDescription == other.displayDescription;
    }

    return false;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      imagePath.hashCode ^
      title.hashCode ^
      subTitle.hashCode ^
      perNight.hashCode ^
      dist.hashCode ^
      rating.hashCode ^
      reviews.hashCode ^
      description.hashCode ^
      features.hashCode ^
      displayDist.hashCode;

  @override
  String toString() => '{$id, $title, $subTitle, $perNight}';
}
