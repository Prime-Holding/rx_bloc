{{> licence.dart }}

import 'dart:developer';

import 'package:dio/dio.dart';

LogInterceptor createDioEventLogInterceptor() => LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: false,
      error: true,
      logPrint: _logDioEvent,
    );

void _logDioEvent(object) {
  log(
    object.toString(),
    time: DateTime.now(),
    name: 'HTTP',
  );
}
