import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../mocks/counter_bloc_mock.dart';

/// wraps a [CounterPage] in a [Provider] of type [CounterBlocType], creating
/// a mocked bloc depending on the values being tested
Widget counterPageFactory({
  String? error,
  int? count,
  bool? isLoading,
}) =>
    Provider<CounterBlocType>(
      create: (_) => counterBlocMockFactory(
        count: count,
        error: error,
        isLoading: isLoading,
      ),
      child: const CounterPage(),
    );
