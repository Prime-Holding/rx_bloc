{{>licence.dart}}

import '../../base/models/errors/error_model.dart';

class CancelledErrorModel extends ErrorModel {
  static const String cancelledAppleMessage =
      'The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000.)';

  static const String cancelledFb =
      'The operation couldn’t be completed. (com.facebook.sdk.core error 8.)';
  static const String facebookFailed = 'FAILED';

  static String googleUserCancelled = 'sign_in_canceled';
}
