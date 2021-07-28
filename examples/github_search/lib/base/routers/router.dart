// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auto_route/auto_route.dart';
import 'package:github_search/feature_github_repo_list/views/github_repo_list_page.dart';

import '../../feature_counter/views/counter_page.dart';
import '../../feature_login/views/login_page.dart';
import '../../feature_notifications/views/notifications_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: CounterPage),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: NotificationsPage),
    MaterialRoute(page: GithubRepoListPage, initial: true),
  ],
)
class $Router {}
