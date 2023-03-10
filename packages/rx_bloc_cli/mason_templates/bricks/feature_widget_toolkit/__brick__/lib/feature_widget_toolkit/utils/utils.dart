import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/language_picker.dart';

import '../../base/models/errors/error_model.dart';
import '../../l10n/l10n.dart';

String translateError(BuildContext context, Exception exception) {
  if (exception is ErrorAccessDeniedModel) {
    return 'Unable to open link on this device. Perhaps you are missing the'
        ' right application to open the link.';
  }
  return exception.toString();
}

class ErrorMapperUtil<T> {
  RxFieldException<T> errorMapper(Object error, BuildContext context) {
    if (error is FieldErrorModel) {
      throw RxFieldExceptionFatory.fromFormField<T>(error, context);
    }
    throw error;
  }
}

extension RxFieldExceptionFatory on RxFieldException {
  static RxFieldException<T> fromFormField<T>(
    FieldErrorModel formFieldModel,
    BuildContext context,
  ) =>
      RxFieldException<T>(
        error: context.l10n.getString(formFieldModel.errorKey) ?? '',
        fieldValue: formFieldModel.fieldValue,
      );
}
