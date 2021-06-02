// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auto_route/auto_route.dart';

import '../../feature_counter/views/counter_page.dart';
import '../../feature_notifications/views/login_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LoginPage, initial: true),
    MaterialRoute(page: CounterPage),
  ],
)
class $Router {}
