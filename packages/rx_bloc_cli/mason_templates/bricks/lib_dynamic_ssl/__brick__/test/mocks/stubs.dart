import 'package:dio/dio.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/lib_dynamic_ssl/models/ssl_fingerprint_model.dart';

class Stubs {
  static final connectionErrorDioException = DioException.connectionError(
    reason: '',
    requestOptions: RequestOptions(),
  );

  static final networkErrorModel = NetworkErrorModel();

  static const String sslFingerprint =
      'a6:35:c9:f6:ec:07:69:bc:58:8e:56:e3:1e:a0:20:4d:0d:07:0e:21:ae:79:fd:35:d6:e9:19:9f:64:c4:bd:0b';

  static final SSLFingerprintModel sslFingerprintModel = SSLFingerprintModel(
    sslFingerprint: sslFingerprint,
  );

  static final SSLFingerprintModel sslFingerprintModelEncrypted =
      SSLFingerprintModel(
    sslFingerprint:
        'WYeEXBUmdeivH+C6R9/H2rRmXZd14UlGdNlvgbP7zl64Ff+xmBbYjVxqmyyJvUI8uC4mBFhzXJzVJlWMbCOJivz4wUlOcfQpZwQNmRHzs1hgvYZAmwnqTEJLeidD1c0r3IIT9Qqd7l8maK0Gu5unsG5sQuucbt69Edcwdh80FWhLkee6Q3SVx74S4sjSISkLd7fGm+1cABLOEfujD5GEqqLozwU0lT3MlJWLseRZGaeXwysziBWkzH0fn+ORkBzlV7VqtHBXAcjhVA55sY0/M3oMQEkLUmgKJpx1yycxkLJDPssfk8gwD1cp9GfLddovid2jwFuWOSycLQYvgAZwKg==',
  );

  static final SSLFingerprintModel sslFingerprintModelEmpty =
      SSLFingerprintModel(sslFingerprint: '');
}
