import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../models/errors/error_model.dart';
import 'error_model_translations.dart';

extension ErrorModelFieldL10n<T> on Stream<T> {
  /// Translate the business error to a user friendly message
  /// based on the error field type
  Stream<T> translate(BuildContext context) {
    return handleError((error) {
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
    });
  }
}
