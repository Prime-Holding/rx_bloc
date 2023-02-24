// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeepLinkListResponseModel _$DeepLinkListResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeepLinkListResponseModel(
      (json['deepLinkList'] as List<dynamic>)
          .map((e) => DeepLinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeepLinkListResponseModelToJson(
        DeepLinkListResponseModel instance) =>
    <String, dynamic>{
      'deepLinkList': instance.deepLinkList,
    };
