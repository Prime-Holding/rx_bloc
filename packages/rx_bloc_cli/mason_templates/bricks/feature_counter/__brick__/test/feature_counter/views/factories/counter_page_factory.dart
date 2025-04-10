{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';{{#has_authentication}}
import 'package:{{project_name}}/lib_auth/blocs/user_account_bloc.dart';
import '../../../base/common_blocs/user_account_bloc_mock.dart';{{/has_authentication}}
import '../../mocks/counter_bloc_mock.dart';

/// wraps a [CounterPage] in a [Provider] of type [CounterBlocType], creating
/// a mocked bloc depending on the values being tested
Widget counterPageFactory({ {{#has_authentication}}
  required bool isLoggedIn,{{/has_authentication}}
  ErrorModel? error,
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
        ),{{#has_authentication}}
        RxBlocProvider<UserAccountBlocType>.value(
          value: userAccountBlocMockFactory(loggedIn: isLoggedIn),
        ),{{/has_authentication}}
      ],
      child: const CounterPage(),
    );
