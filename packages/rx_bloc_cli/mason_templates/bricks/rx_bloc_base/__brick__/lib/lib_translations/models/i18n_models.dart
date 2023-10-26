{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'i18n_models.g.dart';

@JsonSerializable()
class I18nSections {
  I18nSections({required this.item});

  factory I18nSections.fromJson(Map<String, dynamic> json) =>
      _$I18nSectionsFromJson(json);

  @JsonKey(name: 'translations')
  Map<String, Map<String, String>> item;

  Map<String, dynamic> toJson() => _$I18nSectionsToJson(this);
}
