import 'dart:math';

import 'package:collection/collection.dart';

/// Truncated exponential backoff.
mixin RetryWhenMixin {
  List<Duration> get retryDelays;

  var _retryAttempt = 0;

  int get currentRetryAttempts => _retryAttempt;

  int get maxRetryAttempts => retryDelays.length;

  Stream<void> retry(Object error, StackTrace stackTrace) async* {
    // TODO: add custom error handling here if needed

    final retryAfterDuration = retryDelays
            .firstWhereIndexedOrNull((index, _) => index == _retryAttempt) ??
        retryDelays.last;

    // Retry the SSE Stream
    if (_retryAttempt < maxRetryAttempts) {
      _retryAttempt += 1;

      // Add jitter to prevent all synchronized clients from retrying at once.
      final durationWithJitter =
          retryAfterDuration + Duration(milliseconds: Random().nextInt(999));

      yield* Future.delayed(durationWithJitter).asStream();
      return;
    }

    _retryAttempt = 0;
    yield* Stream.error(error, stackTrace);
    return;
  }

  void resetAttempts(_) => _retryAttempt = 0;
}
