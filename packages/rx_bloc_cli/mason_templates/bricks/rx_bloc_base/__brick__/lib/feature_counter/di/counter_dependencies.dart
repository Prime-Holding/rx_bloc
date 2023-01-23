{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/counter_bloc.dart';
import '../services/counter_service.dart';

class CounterDependencies {
  CounterDependencies._(this.context);

  factory CounterDependencies.from(BuildContext context) =>
      CounterDependencies._(context);

  final BuildContext context;

  List<SingleChildWidget> get providers => [
        ..._services,
        ..._blocs,
      ];

  List<Provider> get _services => [
        Provider<CounterService>(
          create: (context) => CounterService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(
            context.read(),
          ),
        ),
      ];
}
