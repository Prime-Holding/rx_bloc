import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'countdown_service.dart';

/// Countdown service implementation
class CountdownServiceImpl implements CountdownService {
  @override
  Stream<int> countDown({int maxTime = 60}) {
    return Stream<int>.periodic(
      const Duration(seconds: 1),
      (computationCount) {
        return maxTime - computationCount - 1;
      },
    ).takeWhile((element) => element >= 0).startWith(maxTime);
  }
}
