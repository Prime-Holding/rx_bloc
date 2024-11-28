import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reminders/base/common_blocs/firebase_bloc.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/feature_dashboard/blocs/dashboard_bloc.dart';
import 'package:reminders/feature_dashboard/models/dashboard_model.dart';
import 'package:reminders/feature_dashboard/views/dashboard_page.dart';
import 'package:reminders/feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';

import '../../mocks/bloc_mocks.dart';
import '../../mocks/reminder_manage_mock.dart';
import '../mock/dashboard_mock.dart';

/// Change the parameters according the the needs of the test
Widget dashboardFactory({
  bool? isLoading,
  String? errors,
  Result<DashboardCountersModel>? dashboardCounters,
  PaginatedList<ReminderModel>? reminderModels,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<ReminderManageBlocType>.value(
            value: reminderManageMockFactory()),
        RxBlocProvider<FirebaseBlocType>.value(value: createFirebaseBlocMock()),
        RxBlocProvider<DashboardBlocType>.value(
          value: dashboardMockFactory(
            isLoading: isLoading,
            errors: errors,
            dashboardCounters: dashboardCounters,
            reminderModels: reminderModels,
          ),
        ),
      ], child: DashboardPage()),
    );
