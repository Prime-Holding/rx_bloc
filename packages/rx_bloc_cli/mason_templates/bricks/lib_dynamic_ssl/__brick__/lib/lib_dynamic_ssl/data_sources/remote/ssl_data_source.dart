// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/ssl_fingerprint_model.dart';

part 'ssl_data_source.g.dart';

@RestApi()
abstract class SSLDataSource {
  factory SSLDataSource(Dio dio, {String baseUrl}) = _SSLDataSource;

  @GET('/api/ssl')
  Future<SSLFingerprintModel> getSSLFingerprint();
}
