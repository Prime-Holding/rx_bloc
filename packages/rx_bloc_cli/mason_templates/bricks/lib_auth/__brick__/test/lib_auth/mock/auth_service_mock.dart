import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_auth/services/auth_service.dart';

import 'auth_service_mock.mocks.dart';

@GenerateMocks([
  AuthService,
])
AuthService authServiceMockFactory() => MockAuthService();
