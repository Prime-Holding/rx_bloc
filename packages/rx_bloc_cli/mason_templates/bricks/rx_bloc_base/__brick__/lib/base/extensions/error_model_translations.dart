import 'package:flutter/widgets.dart';

import '../../app_extensions.dart';
import '../models/errors/error_model.dart';

extension ErrorModelL10n on ErrorModel {
  /// Translate the business error to a user friendly message
  /// based on the error type.
  String translate(BuildContext context) {
    if (this is L10nErrorKeyProvider) {
      return context.l10n.getString((this as L10nErrorKeyProvider).l10nErrorKey)!;
    }

    if (this is BadRequestErrorModel) {
      return (this as BadRequestErrorModel).translate(context);
    }

    if (this is NotFoundErrorModel) {
      return (this as NotFoundErrorModel).translate(context);
    }

    if (this is ConflictErrorModel) {
      return (this as ConflictErrorModel).translate(context);
    }

    if (this is FieldErrorModel) {
      return (this as FieldErrorModel).translate(context);
    }

    if (this is FieldRequiredErrorModel) {
      return (this as FieldRequiredErrorModel).translate(context);
    }

    if (this is ErrorServerGenericModel) {
      return (this as ErrorServerGenericModel).translate(context);
    }

    {{#enable_feature_onboarding}}if (this is InvalidUrlErrorModel) {
      return (this as InvalidUrlErrorModel).translate(context);
    }{{/enable_feature_onboarding}}

    if (this is ErrorTimeoutModel) {
      return (this as ErrorTimeoutModel).translate(context);
    }

    return context.l10n.unknown;
  }
}

extension ErrorBadRequestModelL10n on BadRequestErrorModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.badRequest;
}

extension ErrorNotFoundL10n on NotFoundErrorModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.notFound;
}

extension ConflictErrorModelL10n on ConflictErrorModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.conflict;
}

extension ErrorFieldModelL10n on FieldErrorModel {
  String translate(BuildContext context) {
    return context.l10n.getString(errorKey) ?? 'error';
  }
}

extension ErrorFieldRequiredModelL10n on FieldRequiredErrorModel {
  String translate(BuildContext context) => context.l10n.requiredField(
        context.l10n.getString(fieldKey)!,
      );
}

extension ErrorServerGenericModelL10n on ErrorServerGenericModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.server;
}

{{#enable_feature_onboarding}}extension _InvalidUrlErrorModelL10n on InvalidUrlErrorModel {
  String translate(BuildContext context) => context.l10n.invalidUrl;
}{{/enable_feature_onboarding}}

extension _ErrorTimeoutModelL10n on ErrorTimeoutModel {
  String translate(BuildContext context) =>
      message ?? context.l10n.server;
}
