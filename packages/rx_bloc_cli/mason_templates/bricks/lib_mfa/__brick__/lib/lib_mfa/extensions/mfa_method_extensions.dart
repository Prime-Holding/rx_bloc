import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';
import '../models/mfa_method.dart';

extension MFAMethodX on MFAMethod {
  /// Returns a [RouteDataModel] object based on the [MFAMethod] type.
  ///
  /// The route must be on a root level such as /mfa/pin-biometrics/:transactionId
  ///
  /// - [transactionId] is the transaction id to be used in the route
  /// - if the [MFAMethod] is [MFAMethod.complete] it will return null.
  RouteDataModel? createMFAMethodRoute(String transactionId) {
    switch (this) {
      case MFAMethod.pinBiometric:
        return MFAPinBiometricsRoute(transactionId);
      case MFAMethod.otp:
        return MFAOtpRoute(transactionId);
      case MFAMethod.complete:
        return null;
    }
  }
}
