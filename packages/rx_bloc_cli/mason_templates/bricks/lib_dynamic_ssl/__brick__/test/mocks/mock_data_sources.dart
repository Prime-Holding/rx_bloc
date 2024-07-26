import 'package:mockito/annotations.dart';

import 'package:{{project_name}}/lib_dynamic_ssl/data_sources/remote/ssl_data_source.dart';

import 'mock_data_sources.mocks.dart';

@GenerateMocks([
  SSLDataSource,
])
MockSSLDataSource createMockSSLDataSource() => MockSSLDataSource();
