import 'package:flutter/widgets.dart';

import '../../app_extensions.dart';
import '../models/error/error_model.dart';

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

    return context.l10n.error.unknown;
  }
}

extension ErrorNotFoundL10n on ErrorNotFoundModel {
  String translate(BuildContext context) {
    return message ?? context.l10n.error.notFound;
  }
}
