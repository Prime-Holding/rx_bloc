import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reminders/base/common_blocs/coordinator_bloc.dart';
import 'package:reminders/base/common_blocs/firebase_bloc.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/base/services/reminders_service.dart';
import 'package:reminders/feature_reminder_list/blocs/reminder_list_bloc.dart';
import 'package:reminders/feature_reminder_list/services/reminder_list_service.dart';
import 'package:reminders/feature_reminder_list/views/reminder_list_page.dart';
import 'package:reminders/feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import 'package:rx_bloc_list/models.dart';

import '../../mocks/bloc_mocks.dart';
import '../../mocks/coordinator_mock.dart';
import '../../mocks/reminder_manage_mock.dart';
import '../../mocks/service_mocks.dart';
import '../mock/reminder_list_mock.dart';

/// Change the parameters according the the needs of the test
Widget reminderListFactory({
  bool? isLoading,
  String? errors,
  PaginatedList<ReminderModel>? paginatedList,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        Provider<RemindersService>(
          create: (context) => createRemindersServiceMock(),
        ),
        Provider<ReminderListService>(
          create: (context) => createReminderListServiceMock(),
        ),
        RxBlocProvider<CoordinatorBlocType>.value(
          value: coordinatorMockFactory(),
        ),
        RxBlocProvider<ReminderListBlocType>.value(
          value: reminderListMockFactory(
            isLoading: isLoading,
            errors: errors,
            paginatedList: paginatedList,
          ),
        ),
        RxBlocProvider<FirebaseBlocType>.value(
          value: createFirebaseBlocMock(),
        ),
        RxBlocProvider<ReminderManageBlocType>.value(
          value: reminderManageMockFactory(),
        ),
      ], child: const ReminderListPage()),
    );
