import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable/json_serializable.dart';

part 'counter.g.dart';

@JsonSerializable()
class Counter {
  Counter(this.value);

  @JsonKey()
  int value;

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);
  Map<String, dynamic> toJson() => _$CounterToJson(this);
}