import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';

import 'go_router_mock.mocks.dart';

@GenerateMocks([GoRouter])
GoRouter goRouterMockFactory() => MockGoRouter();
