import 'package:flutter/foundation.dart';

import '../repositories/analytics_repository.dart';

class AnalyticsService {
  AnalyticsService(this._repository);

  final AnalyticsRepository _repository;

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack,
    Map<String, String>? errorLogDetails,
  ) =>
      _repository.recordError(
        exception,
        stack,
        errorLogDetails: errorLogDetails,
      );

  Future<void> logEvent({
    required String eventName,
    Map<String, String>? parameters,
    bool graceful = true,
  }) async {
    try {
      return _repository.logEvent(
        eventName: eventName,
        parameters: parameters,
      );
    } catch (e) {
      if (!graceful) {
        rethrow;
      }

      debugPrint('FirebaseAnalytics: ${e.toString()}');
    }
  }
}
