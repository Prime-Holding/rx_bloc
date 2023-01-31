{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

import '../item_model.dart';

part 'items_list_response_model.g.dart';

@JsonSerializable()
class ItemsListResponseModel {
  ItemsListResponseModel(
      this.items,
      );

  final List<ItemModel> items;

  factory ItemsListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ItemsListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsListResponseModelToJson(this);
}
