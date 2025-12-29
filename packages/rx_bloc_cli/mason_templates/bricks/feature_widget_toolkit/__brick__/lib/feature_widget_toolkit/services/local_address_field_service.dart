{{> licence.dart }}

import 'package:widget_toolkit/text_field_dialog.dart';

import '../../app_extensions.dart';
import '../../base/models/errors/error_model.dart';

class LocalAddressFieldService extends TextFieldValidator<String> {
  static const int minLengthRequired = 2;
  static const int maxLengthRequired = 7;

  @override
  Future<String> validateOnSubmit(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    if (text.length >= maxLengthRequired) {
      throw FieldErrorModel<String>(
        errorKey: S.current.tooLong,
        fieldValue: text,
      );
    }
    return text;
  }

  @override
  void validateOnType(String text) {
    if (text.length < minLengthRequired) {
      throw FieldErrorModel<String>(
        errorKey: S.current.tooShort,
        fieldValue: text,
      );
    }
  }
}
