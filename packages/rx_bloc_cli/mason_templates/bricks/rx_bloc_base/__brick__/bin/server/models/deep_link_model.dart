{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'deep_link_model.g.dart';

@JsonSerializable()
class DeepLinkModel {
  DeepLinkModel({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  factory DeepLinkModel.fromJson(Map<String, dynamic> json) =>
      _$DeepLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeepLinkModelToJson(this);
}
