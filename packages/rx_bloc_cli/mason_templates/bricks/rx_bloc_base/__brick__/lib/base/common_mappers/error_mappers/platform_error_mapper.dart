part of 'error_mapper.dart';

extension _PlatformExceptionErrorMapper on PlatformException {
  ErrorModel asErrorModel() {
    // Implement error mapping.
    return ErrorUnknown(exception: this);
  }
}
