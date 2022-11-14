import 'package:flutter/widgets.dart';

import '../../app_extensions.dart';
import '../models/error/error_model.dart';

extension ErrorModelX on ErrorModel {
  /// Translate the business error to a user friendly message
  /// based on the error type.
  String translate(BuildContext context) {
    if (this is ErrorAccessDeniedModel) {
      return context.l10n.error.accessDenied;
    } else if (this is ErrorGenericModel) {
      return (this as ErrorGenericModel).translate(context);
    } else if (this is ErrorNetworkModel) {
      return context.l10n.error.network;
    } else if (this is ErrorNoConnectionModel) {
      return context.l10n.error.noConnection;
    } else if (this is ErrorNotFoundModel) {
      return (this as ErrorNotFoundModel).message ??
          context.l10n.error.notFound;
    } else if (this is ErrorServerModel) {
      return context.l10n.error.server;
    } else if (this is ErrorUnknown) {
      return (this as ErrorUnknown).translate(context);
    }
    return context.l10n.error.unknown;
  }
}

extension ErrorGenericModelX on ErrorGenericModel {
  String translate(BuildContext context) =>
      context.l10n.error.getString(translationKey)!;
}
