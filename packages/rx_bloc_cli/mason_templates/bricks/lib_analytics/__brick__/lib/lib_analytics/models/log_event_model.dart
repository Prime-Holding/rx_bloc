import 'package:copy_with_extension/copy_with_extension.dart';

import '../../base/models/errors/error_model.dart';
import 'log_model_tags.dart';

part 'log_event_model.g.dart';

const String kErrorLogEndpoint = '{{project_name}}_endpoint';
const String kErrorLogStatusCode = '{{project_name}}_status_code';
const String kErrorLogRequestHeaders = '{{project_name}}_request_headers';
const String kErrorLogResponseHeaders = '{{project_name}}_response_headers';
const String kErrorLogResponseBody = '{{project_name}}_response_body';
const String kErrorLogSentAt = '{{project_name}}_sent_at';
const String kErrorLogDuration = '{{project_name}}_duration';
const String kErrorLogDetails = '{{project_name}}_error_details';

@CopyWith()
class LogEventModel {
  LogEventModel({
    required this.error,
    this.stackTrace,
    this.context,
    this.errorLogDetails,
  });

  ErrorModel error;
  String? stackTrace;
  LogModelContext? context;
  Map<String, String>? errorLogDetails;

  @override
  String toString() {
    return 'LogEventModel{error: $error, stackTrace: $stackTrace, context: $context, errorLogDetails: $errorLogDetails}';
  }
}
