import 'package:flutter/material.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';{{#realtime_communication}}
import 'package:{{project_name}}/base/models/response_models/sse_message_model.dart';{{/realtime_communication}}

class Stubs {
  static const addIcon = Icon(Icons.add);

  static const removeIcon = Icon(Icons.remove);

  static const tooltip = 'This is a tooltip';

  static const appBarTitle = 'Some title';

  static const submit = 'Submit';

  static const customColor = Color.fromRGBO(100, 100, 100, 1);

  static final unknownError =
      UnknownErrorModel(exception: Exception('Some error occur'));

  {{#realtime_communication}}
  static const sseMessageModel = SseMessageModel(
    id: '1',
    data: 'Some message',
    event: 'event Name',
    retry: 1000,
  );
  {{/realtime_communication}}
}
