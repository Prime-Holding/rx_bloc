import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';
import '../models/auth_matrix_method.dart';

extension AuthMatrixMethodX on AuthMatrixMethod {
  /// Returns a [RouteDataModel] object based on the [AuthMatrixMethod] type.
  ///
  /// The route must be on a root level such as /auth-matrix/pin-biometrics/:transactionId
  ///
  /// - [transactionId] is the transaction id to be used in the route
  /// - if the [AuthMatrixMethod] is [AuthMatrixMethod.complete] it will return null.
  RouteDataModel? createAuthMatrixMethodRoute(String transactionId) {
    switch (this) {
      case AuthMatrixMethod.pinBiometric:
        return AuthMatrixPinBiometricsRoute(transactionId);
      case AuthMatrixMethod.otp:
        return AuthMatrixOtpRoute(transactionId);
      case AuthMatrixMethod.complete:
        return null;
    }
  }
}
