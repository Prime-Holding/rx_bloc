import 'package:mockito/annotations.dart';
import 'package:reminders/base/services/firebase_service.dart';
import 'package:reminders/base/services/reminders_service.dart';
import 'package:reminders/feature_dashboard/services/dashboard_service.dart';
import 'package:reminders/feature_reminder_list/services/reminder_list_service.dart';

import 'service_mocks.mocks.dart';

@GenerateMocks([
  RemindersService,
  ReminderListService,
  DashboardService,
  FirebaseService,
])
MockRemindersService createRemindersServiceMock() => MockRemindersService();
MockReminderListService createReminderListServiceMock() =>
    MockReminderListService();
MockDashboardService createDashboardServiceMock() => MockDashboardService();
MockFirebaseService createFirebaseServiceMock() => MockFirebaseService();
