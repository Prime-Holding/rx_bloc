import 'package:flutter/material.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

class Stubs {
  static const addIcon = Icon(Icons.add);

  static const removeIcon = Icon(Icons.remove);

  static const tooltip = 'This is a tooltip';

  static const appBarTitle = 'Some title';

  static const submit = 'Submit';

  static const customColor = Color.fromRGBO(100, 100, 100, 1);

  static final unknownError =
      UnknownErrorModel(exception: Exception('Some error occur'));
}
