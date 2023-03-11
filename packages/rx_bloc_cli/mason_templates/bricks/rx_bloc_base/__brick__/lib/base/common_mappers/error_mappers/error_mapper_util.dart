{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../../l10n/l10n.dart';
import '../../models/errors/error_model.dart';

class ErrorMapperUtil<T> {
  RxFieldException<T> fromErrorModel(Object error, BuildContext context) {
    if (error is ErrorFormFieldModel) {
      throw RxFieldException<T>(
          error: context.l10n.error.getString(error.translationKey) ??
              context.l10n.error.unknown,
          fieldValue: error.fieldValue);
    }

    throw error;
  }
}
