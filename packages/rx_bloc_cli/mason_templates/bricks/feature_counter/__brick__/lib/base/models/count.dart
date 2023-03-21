{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'count.g.dart';

@JsonSerializable()
class Count {

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);
  Count(this.value);

  final int value;
  Map<String, dynamic> toJson() => _$CountToJson(this);
}
