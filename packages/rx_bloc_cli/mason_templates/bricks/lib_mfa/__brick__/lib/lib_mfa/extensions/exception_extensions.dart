import 'package:flutter/services.dart';

import 'package:widget_toolkit/models.dart' as wt_models;
import '../../base/models/errors/error_model.dart';

extension AuthExceptionX on Exception {
  /// Determines whether the exception should be propagated to the MFA consumers
  ///
  /// If true the exception will be propagated to the MFA consumers
  /// If false the exception will be handled internally by the MFA method
  bool get isAuthMethodException => switch (this) {
        NetworkErrorModel _ => true,
        ErrorServerGenericModel _ => true,
        wt_models.UnknownErrorModel uem => _handleUnknownErrors(uem),
        NotFoundErrorModel _ => false,
        Exception _ => false,
      };

  bool _handleUnknownErrors(wt_models.UnknownErrorModel uem) {
    // Check if the exception came from the OS
    if (uem.exception case PlatformException platformException) {
      // Canceled biometrics authentication will respond with
      // `NotAvailable` code, so check against it
      return platformException.code == 'NotAvailable';
    }

    return false;
  }
}
