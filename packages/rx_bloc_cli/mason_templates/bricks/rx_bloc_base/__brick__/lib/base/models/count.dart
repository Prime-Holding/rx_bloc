import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable/json_serializable.dart';

// part 'counter.g.dart';

@JsonSerializable()
class Count {
  Count(this.value);

  final int value;

  // factory Count.fromJson(Map<String, dynamic> json) =>
  //     _$CounterFromJson(json);
  // Map<String, dynamic> toJson() => _$CounterToJson(this);
}