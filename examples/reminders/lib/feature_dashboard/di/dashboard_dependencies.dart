import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/dashboard_bloc.dart';

class DashboardDependencies {
  DashboardDependencies._(this.context);

  factory DashboardDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = DashboardDependencies._(context);

  static DashboardDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._blocs,
  ];

  late final List<Provider> _repositories = [];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<DashboardBlocType>(
      create: (context) => DashboardBloc(),
    ),
  ];
}
