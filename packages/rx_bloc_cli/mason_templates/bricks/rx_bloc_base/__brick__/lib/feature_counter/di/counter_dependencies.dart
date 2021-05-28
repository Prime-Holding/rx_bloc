// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/count_data_source/count_data_source.dart';
import '../../base/count_data_source/count_local_data_source.dart';
import '../../base/count_data_source/count_remote_data_source.dart';
import '../../base/repositories/counter_repository.dart';
import '../blocs/counter_bloc.dart';

class CounterDependencies {
  CounterDependencies._(this.context);

  factory CounterDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = CounterDependencies._(context);

  static CounterDependencies? _instance;

  final BuildContext context;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
        ..._dataSources,
        ..._repositories,
        ..._blocs,
      ];

  List<Provider> get _dataSources => [
    Provider<CountDataSource>(
      /// Here make your chose witch data source to use
      /// If want to use remote data source should provide a real api
      /// in lib\base\count_data_source\count_remote_data_source.dart
      /// and rerun build_runner
      // create: (context) => CountRemoteDataSource(context.read()),
      create: (context) => CountLocalDataSource(),
    ),
      ];

  List<Provider> get _repositories => [
        Provider<CounterRepository>(
          create: (context) => CounterRepository(context.read()),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(context.read()),
        ),
      ];
}
