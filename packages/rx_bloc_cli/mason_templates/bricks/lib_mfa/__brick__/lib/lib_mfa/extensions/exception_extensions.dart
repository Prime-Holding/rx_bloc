import '../../base/models/errors/error_model.dart';

extension AuthExceptionX on Exception {
  /// Determines whether the exception should be propagated to the MFA consumers
  ///
  /// If true the exception will be propagated to the MFA consumers
  /// If false the exception will be handled internally by the MFA method
  bool get isAuthMethodException => switch (this) {
        NetworkErrorModel _ => true,
        ErrorServerGenericModel _ => true,
        NotFoundErrorModel _ => false,
        Exception _ => false,
      };
}
