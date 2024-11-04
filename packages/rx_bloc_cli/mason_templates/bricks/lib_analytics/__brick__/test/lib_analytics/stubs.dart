import 'package:{{project_name}}/base/models/errors/error_model.dart';

class Stubs {
  static const eventName = 'eventname';

  static final eventParameters = Map<String, String>.from({'key': 'value'});

  static final unknownError =
      UnknownErrorModel(exception: Exception('Some error occur'));
}
