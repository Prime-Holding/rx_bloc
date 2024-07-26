import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/app/config/app_constants.dart';
import 'package:{{project_name}}/base/app/config/environment_config.dart';
import 'package:{{project_name}}/base/env/app_env.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/lib_dynamic_ssl/models/ssl_fingerprint_model.dart';
import 'package:{{project_name}}/lib_dynamic_ssl/services/ssl_service.dart';

import '../../mocks/mock_repositories.dart';
import '../../mocks/mock_repositories.mocks.dart';
import '../../mocks/stubs.dart';

void main() {
  late MockSSLRepository sslRepository;
  late SSLService sslService;

  void defineWhen({
    SSLFingerprintModel? sslFingerprintModel,
    bool hasError = false,
  }) {
    when(sslRepository.getSSLFingerprint()).thenAnswer((_) => hasError
        ? Future.error(Stubs.networkErrorModel)
        : Future.value(
            sslFingerprintModel ?? Stubs.sslFingerprintModelEncrypted));
  }

  setUp(() {
    isTest = true;
    sslRepository = createMockSSLRepository();
    sslService = SSLService(
      AppEnv(EnvironmentConfig.development),
      sslRepository,
    );
  });

  group('SSLService tests', () {
    test(
      'test SSLService load',
      () async {
        defineWhen();

        final fingerprint = await sslService.load();

        expect(
          fingerprint,
          Stubs.sslFingerprint,
        );
      },
    );
    test(
      'test SSLService getSSLFingerprintSync',
      () async {
        defineWhen();

        await sslService.load();
        final fingerprint = sslService.getSSLFingerprintSync();

        expect(
          fingerprint,
          Stubs.sslFingerprint,
        );
      },
    );
    test(
      'test SSLService getSSLFingerprint error',
      () async {
        defineWhen(hasError: true);

        try {
          await sslService.load();
        } catch (exception) {
          expect(exception, isA<NetworkErrorModel>());
          return;
        }
      },
    );
    test(
      'test SSLService getSSLFingerprint empty',
      () async {
        defineWhen(sslFingerprintModel: Stubs.sslFingerprintModelEmpty);

        try {
          await sslService.load();
        } catch (exception) {
          expect(exception, isA<ErrorServerGenericModel>());
          return;
        }
      },
    );
  });
}
