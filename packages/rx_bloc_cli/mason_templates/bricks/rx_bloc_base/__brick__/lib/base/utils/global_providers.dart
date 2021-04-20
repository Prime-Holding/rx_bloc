import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_counter/bloc/counter_bloc.dart';
import '../repositories/counter_repository.dart';

class GlobalProviders {
  GlobalProviders._(this.context);

  factory GlobalProviders.of(BuildContext context) =>
      GlobalProviders._(context);

  final BuildContext context;

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

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
        ..._repositories,
        ..._blocs,
      ];
}
