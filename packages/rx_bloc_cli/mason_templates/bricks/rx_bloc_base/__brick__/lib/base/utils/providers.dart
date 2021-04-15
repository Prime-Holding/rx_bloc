import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:{{project_name}}/base/repositories/counter_repository.dart';
import 'package:{{project_name}}/feature_counter/bloc/counter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static final _counterRepo = CounterRepository();

  static final _blocs = [
    RxBlocProvider<CounterBlocType>(
      create: (context) => CounterBloc(_counterRepo),
    ),
  ];

  /// List of all providers used throughout the app
  static List<SingleChildWidget> allProviders = [
    ..._blocs,
  ];
}
