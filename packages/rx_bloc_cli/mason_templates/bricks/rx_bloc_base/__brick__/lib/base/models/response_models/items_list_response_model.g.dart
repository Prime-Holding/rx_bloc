// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemsListResponseModel _$ItemsListResponseModelFromJson(
        Map<String, dynamic> json) =>
    ItemsListResponseModel(
      (json['items'] as List<dynamic>)
          .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemsListResponseModelToJson(
        ItemsListResponseModel instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
