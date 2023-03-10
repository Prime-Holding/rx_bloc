import 'package:widget_toolkit/text_field_dialog.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';

class LocalAddressFieldService extends TextFieldValidator<String> {
  static const int minLengthRequired = 2;
  static const int maxLengthRequired = 7;

  @override
  Future<String> validateOnSubmit(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    if (text.length >= maxLengthRequired) {
      await Future.delayed(const Duration(seconds: 1));
      throw FieldErrorModel<String>(
        ///TODO: Add the proper key
        ///// error: 'Please enter at max $maxLengthRequired symbols',
        errorKey: I18nErrorKeys.passwordLength,
        fieldValue: text,
      );
    }
    return text;
  }

  @override
  void validateOnType(String text) {
    if (text.length < minLengthRequired) {
      throw FieldErrorModel<String>(
        // error: 'Please enter at least $minLengthRequired symbols',
        ///TODO: Add the proper key
        errorKey: I18nErrorKeys.passwordLength,
        fieldValue: text,
      );
    }
  }
}
