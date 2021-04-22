import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/repositories/counter_repository.dart';
import '../blocs/counter_bloc.dart';

class CounterDependencies {
  CounterDependencies._(this.context);

  factory CounterDependencies.of(BuildContext context) =>
      CounterDependencies._(context);

  final BuildContext context;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
        ..._repositories,
        ..._blocs,
      ];

  List<Provider> get _repositories => [
        Provider<CounterRepository>(
          create: (context) => CounterRepository(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(context.read()),
        ),
      ];
}
