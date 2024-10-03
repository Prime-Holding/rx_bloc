import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_auth/services/user_account_service.dart';

import 'user_account_service_mock.mocks.dart';

@GenerateMocks([
  UserAccountService,
])
UserAccountService userAccountServiceMockFactory() => MockUserAccountService();
