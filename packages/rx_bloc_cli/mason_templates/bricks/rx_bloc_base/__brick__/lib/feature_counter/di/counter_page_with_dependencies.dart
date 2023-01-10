{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/data_sources/remote/count_remote_data_source.dart';
import '../../base/repositories/counter_repository.dart';
import '../blocs/counter_bloc.dart';
import '../views/counter_page.dart';

class CounterPageWithDependencies extends StatelessWidget {
  const CounterPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [
        ..._dataSources,
        ..._repositories,
        ..._blocs,
      ],
      child: const CounterPage(),
    );

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
          create: (context) => CounterRepository(
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(repository: context.read()),
        ),
      ];
}
