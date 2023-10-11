import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../base/common_mappers/error_mappers/error_mapper.dart';

class AnalyticsRepository {
  final ErrorMapper _errorMapper;
  final FirebaseCrashlytics _crashlytics;
  final FirebaseAnalytics _analytics;

  AnalyticsRepository(this._errorMapper, this._crashlytics, this._analytics);

  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
    await _analytics.setUserId(id: identifier);
  }

  Future<void> logout() async {
    unawaited(_crashlytics.setUserIdentifier(''));
    unawaited(_analytics.setUserId(id: ''));
  }

  Future<void> recordError(
      dynamic exception,
      StackTrace? stack, {
        Map<String, String>? errorLogDetails,
        dynamic reason,
        Iterable<Object> information = const [],
        bool? printDetails,
        bool fatal = false,
      }) async {
    if (errorLogDetails != null) {
      //add keys to crashlytics
      for (var entry in errorLogDetails.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    }

    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  Future<void> logEvent({
    required String eventName,
    Map<String, String>? parameters,
  }) =>
      _errorMapper.execute(
            () => _analytics.logEvent(
          name: eventName,
          parameters: parameters,
        ),
      );
}
