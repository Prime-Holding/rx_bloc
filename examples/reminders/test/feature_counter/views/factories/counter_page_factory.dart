// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reminders/base/common_blocs/user_account_bloc.dart';
import 'package:reminders/feature_counter/blocs/counter_bloc.dart';
import 'package:reminders/feature_counter/views/counter_page.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../../base/common_blocs/user_account_bloc_mock.dart';
import '../../mocks/counter_bloc_mock.dart';

/// wraps a [CounterPage] in a [Provider] of type [CounterBlocType], creating
/// a mocked bloc depending on the values being tested
Widget counterPageFactory({
  required bool isLoggedIn,
  String? error,
  int? count,
  LoadingWithTag? isLoading,
}) =>
    MultiProvider(
      providers: [
        RxBlocProvider<CounterBlocType>.value(
          value: counterBlocMockFactory(
            count: count,
            error: error,
            isLoading: isLoading,
          ),
        ),
        RxBlocProvider<UserAccountBlocType>.value(
          value: userAccountBlocMockFactory(loggedIn: isLoggedIn),
        ),
      ],
      child: const CounterPage(),
    );
