{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';

import '../../helpers/golden_helper.dart';
import 'factories/counter_page_factory.dart';

void main() {
  group(
    'CounterPage golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          scenario:  'counter',
          widget: counterPageFactory(
            count: 2{{#has_authentication}},
            isLoggedIn: true{{/has_authentication}},
            isLoading: LoadingWithTag(
              loading: false,
              tag: CounterBloc.tagIncrement,
            ),
          ),
        ),
        buildScenario(
          scenario: 'error',
          widget: counterPageFactory(
            count: 2,
            error: NetworkErrorModel(),{{#has_authentication}}
            isLoggedIn: false,{{/has_authentication}}
          ),
        ),
        buildScenario(
          scenario: 'loading',
          customPumpBeforeTest: animationCustomPump,
          widget: counterPageFactory(
            count: 2,{{#has_authentication}}
            isLoggedIn: false,{{/has_authentication}}
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
