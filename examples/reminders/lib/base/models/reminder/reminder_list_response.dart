import 'package:json_annotation/json_annotation.dart';

import 'reminder_model.dart';

part 'reminder_list_response.g.dart';

@JsonSerializable()
class ReminderListResponse {
  ReminderListResponse({
    required this.items,
    this.totalCount,
  });

  final List<ReminderModel> items;
  final int? totalCount;

  factory ReminderListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReminderListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderListResponseToJson(this);
}
