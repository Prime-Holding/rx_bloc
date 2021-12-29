// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/feature_counter/blocs/counter_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import 'factories/counter_page_factory.dart';

void main() {
  group(
    'CounterPage golden tests',
    () => runGoldenTests(
      [
        generateDeviceBuilder(
          scenario: Scenario(name: 'counter'),
          widget: counterPageFactory(count: 2, isLoggedIn: true),
        ),
        generateDeviceBuilder(
          scenario: Scenario(name: 'error'),
          widget: counterPageFactory(
            count: 2,
            error: 'Test errors',
            isLoggedIn: false,
          ),
        ),
        generateDeviceBuilder(
          scenario: Scenario(name: 'loading'),
          widget: counterPageFactory(
            count: 2,
            isLoggedIn: false,
            isLoading: LoadingWithTag(
              loading: true,
              tag: CounterBloc.tagIncrement,
            ),
          ),
        ),
      ],
    ),
  );
}
