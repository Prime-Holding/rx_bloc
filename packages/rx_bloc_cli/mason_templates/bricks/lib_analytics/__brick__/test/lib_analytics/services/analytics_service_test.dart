import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_analytics/repositories/analytics_repository.dart';
import 'package:{{project_name}}/lib_analytics/services/analytics_service.dart';

import '../stubs.dart';
import 'analytics_service_test.mocks.dart';

@GenerateMocks([AnalyticsRepository])
void main() {
  late MockAnalyticsRepository mockRepository;
  late AnalyticsService todoActionsService;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    todoActionsService = AnalyticsService(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('AnalyticsService', () {
    test('recordError should call repository.recordError', () async {
      final exception = Stubs.unknownError;

      await todoActionsService.recordError(
          exception, null, exception.errorLogDetails);

      verify(mockRepository.recordError(exception, null,
              errorLogDetails: exception.errorLogDetails))
          .called(1);
    });

    test('logEvent should call repository.logEvent', () async {
      const eventName = Stubs.eventName;
      final parameters = Stubs.eventParameters;

      await todoActionsService.logEvent(
          eventName: eventName, parameters: parameters);

      verify(mockRepository.logEvent(
              eventName: eventName, parameters: parameters))
          .called(1);
    });
  });
}
