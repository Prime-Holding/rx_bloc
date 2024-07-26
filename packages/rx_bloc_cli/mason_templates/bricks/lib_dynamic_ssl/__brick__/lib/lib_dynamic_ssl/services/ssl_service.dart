// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../base/common_services/rsa_service.dart';
import '../../base/env/app_env.dart';
import '../../base/models/errors/error_model.dart';
import '../repositories/ssl_repository.dart';

class SSLService {
  SSLService(this._appEnv, this._repository);

  final AppEnv _appEnv;
  final SSLRepository _repository;
  String _sslFingerprint = '';

  String getSSLFingerprintSync() => _sslFingerprint;

  Future<String> getSSLFingerprint({bool force = false}) async {
    if (_sslFingerprint.isEmpty || force) {
      final sslFingerprintModel = await _repository.getSSLFingerprint();

      if (sslFingerprintModel.sslFingerprint.isEmpty) {
        throw ErrorServerGenericModel(
          message: 'Failed to fetch SSL fingerprint',
        );
      }

      RSAPrivateKey privateKey =
          RSAKeyParser().parse('''-----BEGIN PRIVATE KEY-----
${_appEnv.sslPrivateKey.replaceAll(' ', '\n')}
-----END PRIVATE KEY-----''') as RSAPrivateKey;

      _sslFingerprint = RSAService().rsaDecrypt(
        privateKey,
        sslFingerprintModel.sslFingerprint,
      );
    }

    return _sslFingerprint;
  }

  /// Load SSL fingerprint
  Future<String> load() => getSSLFingerprint(force: true);
}
