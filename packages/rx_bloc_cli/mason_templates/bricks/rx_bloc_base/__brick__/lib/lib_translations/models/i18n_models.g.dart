// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i18n_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

I18nSections _$I18nSectionsFromJson(Map<String, dynamic> json) => I18nSections(
      item: (json['translations'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
    );

Map<String, dynamic> _$I18nSectionsToJson(I18nSections instance) =>
    <String, dynamic>{
      'translations': instance.item,
    };
