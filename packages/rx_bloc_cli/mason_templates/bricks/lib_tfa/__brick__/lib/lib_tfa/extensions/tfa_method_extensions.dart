import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';
import '../models/tfa_method.dart';

extension TFAMethodX on TFAMethod {
  /// Returns a [RouteDataModel] object based on the [TFAMethod] type.
  ///
  /// The route must be on a root level such as /tfa/pin-biometrics/:transactionId
  ///
  /// - [transactionId] is the transaction id to be used in the route
  /// - if the [TFAMethod] is [TFAMethod.complete] it will return null.
  RouteDataModel? createTFAMethodRoute(String transactionId) {
    switch (this) {
      case TFAMethod.pinBiometric:
        return TFAPinBiometricsRoute(transactionId);
      case TFAMethod.otp:
        return TFAOtpRoute(transactionId);
      case TFAMethod.complete:
        return null;
    }
  }
}
