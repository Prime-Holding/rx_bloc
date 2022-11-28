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

    if (this is ErrorNotFoundModel) {
      return (this as ErrorNotFoundModel).translate(context);
    }

    if (this is ErrorFieldModel) {
      return (this as ErrorFieldModel).translate(context);
    }

    if (this is ErrorFieldRequiredModel) {
      return (this as ErrorFieldRequiredModel).translate(context);
    }

    return context.l10n.error.unknown;
  }
}

extension ErrorNotFoundL10n on ErrorNotFoundModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.error.notFound;
}

extension ErrorFieldRequiredModelL10n on ErrorFieldRequiredModel {
  String translate(BuildContext context) => context.l10n.error.requiredField(
        context.l10n.field.getString(fieldKey)!,
      );
}

extension ErrorFieldModelL10n on ErrorFieldModel {
  String translate(BuildContext context) =>
      context.l10n.error.getString(fieldKey)!;
}
