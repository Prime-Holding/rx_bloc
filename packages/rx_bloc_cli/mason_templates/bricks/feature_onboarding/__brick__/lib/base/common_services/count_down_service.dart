{{> licence.dart }}

import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CountDownService {
  /// Starts a countdown from the provided number of seconds down to 0
  Stream<int> startCountDown({int countDown = 50}) => Stream.periodic(
        const Duration(seconds: 1),
        (computationCount) => countDown - computationCount - 1,
      ).takeWhile((count) => count >= 0).startWith(countDown);
}
