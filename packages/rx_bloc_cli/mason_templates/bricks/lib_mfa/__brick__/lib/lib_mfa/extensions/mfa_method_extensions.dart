import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';
import '../models/mfa_method.dart';

extension MfaMethodX on MfaMethod {
  /// Returns a [RouteDataModel] object based on the [MfaMethod] type.
  ///
  /// The route must be on a root level such as /mfa/pin-biometrics/:transactionId
  ///
  /// - [transactionId] is the transaction id to be used in the route
  /// - if the [MfaMethod] is [MfaMethod.complete] it will return null.
  RouteDataModel? createMfaMethodRoute(String transactionId) {
    switch (this) {
      case MfaMethod.pinBiometric:
        return MfaPinBiometricsRoute(transactionId);
      case MfaMethod.otp:
        return MfaOtpRoute(transactionId);
      case MfaMethod.complete:
        return null;
    }
  }
}
