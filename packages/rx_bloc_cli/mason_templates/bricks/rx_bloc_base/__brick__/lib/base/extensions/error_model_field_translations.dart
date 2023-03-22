{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/language_picker.dart';

import '../models/errors/error_model.dart';
import 'error_model_translations.dart';

extension ErrorModelFieldL10nX<T> on Stream<T> {
  /// Translate the business error to a user friendly message
  /// based on the error field type
  Stream<T> translate(BuildContext context) {
    return handleError(
          (error) => ErrorModelFieldL10n.translateError<T>(error, context),
    );
  }
}

class ErrorModelFieldL10n {
  static T translateError<T>(Object error, BuildContext context) {
    if (error is ErrorUnknown && error.exception is FieldErrorModel<T>) {
      throw RxFieldException<T>(
        error: (error.exception as FieldErrorModel<T>).translate(context),
        fieldValue: (error.exception as FieldErrorModel<T>).fieldValue,
      );
    }

    if (error is FieldErrorModel) {
      throw RxFieldException<T>(
        error: error.translate(context),
        fieldValue: error.fieldValue,
      );
    }

    if (error is FieldRequiredErrorModel) {
      throw RxFieldException<T>(
        error: error.translate(context),
        fieldValue: error.fieldValue,
      );
    }

    throw error;
  }
}
