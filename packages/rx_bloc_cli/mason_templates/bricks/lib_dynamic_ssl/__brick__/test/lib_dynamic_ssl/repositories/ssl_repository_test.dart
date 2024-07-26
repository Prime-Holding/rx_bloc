import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/common_mappers/error_mappers/error_mapper.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/lib_dynamic_ssl/repositories/ssl_repository.dart';

import '../../mocks/coordinator_mock.dart';
import '../../mocks/mock_data_sources.dart';
import '../../mocks/mock_data_sources.mocks.dart';
import '../../mocks/stubs.dart';

void main() {
  late MockSSLDataSource sslDataSource;
  late SSLRepository sslRepository;

  void defineWhen({
    bool hasError = false,
  }) {
    when(sslRepository.getSSLFingerprint()).thenAnswer((_) => hasError
        ? Future.error(Stubs.connectionErrorDioException)
        : Future.value(Stubs.sslFingerprintModelEncrypted));
  }

  setUp(() {
    sslDataSource = createMockSSLDataSource();
    sslRepository =
        SSLRepository(sslDataSource, ErrorMapper(coordinatorMockFactory()));
  });

  group('SSLRepository tests', () {
    test(
      'test SSLRepository getSSLFingerprint',
      () async {
        defineWhen();

        final fingerprint = await sslRepository.getSSLFingerprint();

        expect(
          fingerprint,
          Stubs.sslFingerprintModelEncrypted,
        );
      },
    );
    test(
      'test SSLRepository getSSLFingerprint error',
      () async {
        defineWhen(hasError: true);

        try {
          await sslRepository.getSSLFingerprint();
        } catch (exception) {
          expect(exception, isA<NetworkErrorModel>());
          return;
        }
      },
    );
  });
}
