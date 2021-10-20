{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/data_sources/remote/count_remote_data_source.dart';
import '../../base/repositories/counter_repository.dart';
import '../blocs/counter_bloc.dart';

class CounterDependencies {
  CounterDependencies._(this.context);

  factory CounterDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = CounterDependencies._(context);

  static CounterDependencies? _instance;

  final BuildContext context;

  List<SingleChildWidget> get providers => [
        ..._dataSources,
        ..._repositories,
        ..._blocs,
      ];

  /// For your project you should provide a real api in
  /// lib\base\data_sources\domain\counter\count_remote_data_source.dart
  /// and data models in lib\base\models and rerun build_runner.
  List<Provider> get _dataSources => [
        Provider<CountRemoteDataSource>(
          create: (context) => CountRemoteDataSource(context.read()),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<CounterRepository>(
          create: (context) => CounterRepository(context.read()),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(repository: context.read()),
        ),
      ];
}
