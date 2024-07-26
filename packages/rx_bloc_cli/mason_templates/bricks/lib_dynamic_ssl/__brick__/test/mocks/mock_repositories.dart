import 'package:mockito/annotations.dart';

import 'package:{{project_name}}/lib_dynamic_ssl/repositories/ssl_repository.dart';

import 'mock_repositories.mocks.dart';

@GenerateMocks([
  SSLRepository,
])
MockSSLRepository createMockSSLRepository() => MockSSLRepository();
