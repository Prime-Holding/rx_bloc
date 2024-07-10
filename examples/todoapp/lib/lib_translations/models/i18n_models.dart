// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
