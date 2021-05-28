import 'package:equatable/equatable.dart';

class HotelFullExtraDetails extends Equatable {
  HotelFullExtraDetails({
    required this.id,
    required this.hotelId,
    required this.description,
    required this.features,
  });

  final String id;
  final List<String> hotelId;
  final String description;
  final List<String> features;

  @override
  List<Object?> get props => [
        id,
        hotelId,
        description,
        features,
      ];

  HotelFullExtraDetails copyWith({
    String? id,
    List<String>? hotelId,
    String? description,
    List<String>? features,
  }) =>
      HotelFullExtraDetails(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        description: description ?? this.description,
        features: features ?? this.features,
      );

  HotelFullExtraDetails.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          hotelId: json['hotelId'].cast<String>() as List<String>,
          features: json['features'].cast<String>() as List<String>,
          description: json['description'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'features': features,
      'description': description,
    };
  }
}
