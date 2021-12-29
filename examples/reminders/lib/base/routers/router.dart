// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auto_route/auto_route.dart';

import '../../feature_dashboard/views/dashboard_page.dart';
import '../../feature_navigation/views/navigation_page.dart';
import '../../feature_reminder_list/views/reminder_list_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: NavigationPage, initial: true, children: [
      MaterialRoute(page: DashboardPage),
      MaterialRoute(page: ReminderListPage),
    ]),
  ],
)
class $Router {}
