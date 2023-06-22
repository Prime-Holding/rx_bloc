import 'package:widget_toolkit/text_field_dialog.dart';

class OtpTextFieldValidator extends TextFieldValidator<String> {
  @override
  Future<String> validateOnSubmit(String text) async => text;

  @override
  void validateOnType(String text) => true;
}
