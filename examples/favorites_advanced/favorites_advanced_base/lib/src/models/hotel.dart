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
  bool isFavorite;

  // Properties that should simulate remote fetching of entity data
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
    this.displaySubtitle,
    this.displayReviews,
    this.displayRating,
    this.displayDist,
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
    bool? isFavorite,
    String? displaySubtitle,
    int? displayReviews,
    double? displayRating,
    double? displayDist,
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
        displaySubtitle: displaySubtitle ?? this.displaySubtitle,
        displayReviews: displayReviews ?? this.displayReviews,
        displayRating: displayRating ?? this.displayRating,
        displayDist: displayDist ?? this.displayDist,
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
        displaySubtitle: hotel.displaySubtitle ?? displaySubtitle,
        displayReviews: hotel.displayReviews ?? displayReviews,
        displayRating: hotel.displayRating ?? displayRating,
        displayDist: hotel.displayDist ?? displayDist,
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

  @override
  bool operator ==(Object other) {
    if (other is Hotel) {
      return id == other.id &&
          imagePath == other.imagePath &&
          title == other.title &&
          subTitle == other.subTitle &&
          perNight == other.perNight &&
          dist == other.dist &&
          rating == other.rating &&
          reviews == other.reviews &&
          displayDist == other.displayDist;
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
      displayDist.hashCode;

  @override
  String toString() => '{$id, $title, $subTitle, $perNight}';
}
