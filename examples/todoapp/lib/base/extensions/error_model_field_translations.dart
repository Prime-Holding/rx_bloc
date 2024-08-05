// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

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
    if (error is UnknownErrorModel && error.exception is FieldErrorModel<T>) {
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
