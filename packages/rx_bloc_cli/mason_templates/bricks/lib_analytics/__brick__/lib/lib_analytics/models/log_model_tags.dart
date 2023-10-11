import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_model_tags.g.dart';

enum LogModelContext { errorMapper, flutterError }

@JsonSerializable()
@CopyWith()
class LogModelTags {
  LogModelTags({
    required this.env,
    required this.dc,
    this.context,
  });

  final String env;
  final String dc;
  final LogModelContext? context;

  factory LogModelTags.fromJson(Map<String, dynamic> json) =>
      _$LogModelTagsFromJson(json);

  Map<String, dynamic> toJson() => _$LogModelTagsToJson(this);

  @override
  String toString() {
    return 'LogModelTags{env: $env, dc: $dc, context: $context}';
  }
}
