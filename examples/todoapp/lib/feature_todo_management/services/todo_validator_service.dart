import '../../assets.dart';
import '../../base/models/errors/error_model.dart';

class TodoValidatorService {
  TodoValidatorService();

  String validateTitle(String title) {
    if (title.trim().isEmpty) {
      throw FieldRequiredErrorModel(
        fieldKey: I18nFieldKeys.title,
        fieldValue: title,
      );
    }
    if (title.length < 3) {
      throw FieldErrorModel(
        errorKey: I18nErrorKeys.tooShort,
        fieldValue: title,
      );
    }
    if (title.length > 30) {
      throw FieldErrorModel(
        errorKey: I18nErrorKeys.tooLong,
        fieldValue: title,
      );
    }
    return title;
  }
}
