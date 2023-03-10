{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

import '../deep_link_model.dart';

part 'deep_link_list_response_model.g.dart';

@JsonSerializable()
class DeepLinkListResponseModel {
  DeepLinkListResponseModel(
      this.deepLinkList,
      );

  final List<DeepLinkModel> deepLinkList;

  factory DeepLinkListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeepLinkListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeepLinkListResponseModelToJson(this);
}
