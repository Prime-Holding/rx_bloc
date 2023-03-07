import 'package:flutter/widgets.dart';

import '../../app_extensions.dart';
import '../models/errors/error_model.dart';

extension ErrorModelL10n on ErrorModel {
  /// Translate the business error to a user friendly message
  /// based on the error type.
  String translate(BuildContext context) {
    if (this is L10nErrorKeyProvider) {
      return context.l10n.error
          .getString((this as L10nErrorKeyProvider).l10nErrorKey)!;
    }

    if (this is NotFoundErrorModel) {
      return (this as NotFoundErrorModel).translate(context);
    }

    if (this is FieldErrorModel) {
      return (this as FieldErrorModel).translate(context);
    }

    if (this is FieldRequiredErrorModel) {
      return (this as FieldRequiredErrorModel).translate(context);
    }

    return context.l10n.error.unknown;
  }
}

extension ErrorNotFoundL10n on NotFoundErrorModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.error.notFound;
}

extension ErrorFieldModelL10n on FieldErrorModel {
  String translate(BuildContext context) =>
      context.l10n.error.getString(errorKey)!;
}

extension ErrorFieldRequiredModelL10n on FieldRequiredErrorModel {
  String translate(BuildContext context) => context.l10n.error.requiredField(
        context.l10n.field.getString(fieldKey)!,
      );
}
