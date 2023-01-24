{{> licence.dart }}

import 'dart:developer';

import 'package:dio/dio.dart';

LogInterceptor createDioEventLogInterceptor(String clientName) =>
    LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: false,
      error: true,
      logPrint: (object) => _logDioEvent(object, clientName),
    );

void _logDioEvent(Object object, String clientName) {
  log(
    object.toString(),
    time: DateTime.now(),
    name: clientName,
  );
}
