{{> licence.dart }}

import 'package:widget_toolkit/widget_toolkit.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';

class EnterMessageFieldService extends TextFieldValidator<String> {
  static const int minLengthRequired = 2;

  @override
  Future<String> validateOnSubmit(String text) async => text;

  @override
  void validateOnType(String text) {
    if (text.length < minLengthRequired) {
      throw FieldErrorModel<String>(
        fieldValue: text,
        errorKey: I18nErrorKeys.invalidMessage,
      );
    }
  }
}
