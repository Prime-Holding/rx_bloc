// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SetupProxy on HttpClientAdapter {
  Future<void> setupProxy() async {
    String proxy = (await _instance).getString('dev_menu_http_proxy') ?? '';
    (this as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      if (proxy.isNotEmpty) {
        client.findProxy = ((uri) {
          return 'PROXY $proxy:8888';
        });
        client.badCertificateCallback = ((cert, host, port) => true);
      }
      return client;
    };
  }

  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();
}
