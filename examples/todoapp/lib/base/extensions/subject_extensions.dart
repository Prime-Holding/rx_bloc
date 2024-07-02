import 'package:rxdart/rxdart.dart';

extension SubjectExtensions on Subject {
  /// check if the subject is closed before closing it
  void closeSafely() {
    if (!isClosed) {
      close();
    }
  }
}
