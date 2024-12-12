{{> licence.dart }}

import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CountDownService {
  static const maxTime = 50;
  static const countDownTime = 300;
  static const countZeroDownTime = 0;

  Stream<int> startCountDown({int countDown = maxTime}) => Stream.periodic(
        const Duration(seconds: 1),
        (computationCount) => countDown - computationCount - 1,
      ).takeWhile((count) => count >= 0).startWith(countDown);
}
