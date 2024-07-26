// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/ssl_data_source.dart';
import '../models/ssl_fingerprint_model.dart';

class SSLRepository {
  SSLRepository(this._dataSource, this._errorMapper);

  final SSLDataSource _dataSource;
  final ErrorMapper _errorMapper;

  Future<SSLFingerprintModel> getSSLFingerprint() =>
      _errorMapper.execute(_dataSource.getSSLFingerprint);
}
