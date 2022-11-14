part of 'error_mapper.dart';

extension _StateErrorMapper on StateError {
  ErrorModel asErrorModel() {
    if (toString() == 'Bad state: No element') {
      return ErrorNotFoundModel();
    }

    return ErrorUnknown(error: this);
  }
}
