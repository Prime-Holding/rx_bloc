// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
