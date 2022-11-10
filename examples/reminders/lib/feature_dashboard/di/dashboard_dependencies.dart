import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/dashboard_bloc.dart';
import '../services/dashboard_service.dart';

class DashboardDependencies {
  DashboardDependencies._(this.context);

  factory DashboardDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = DashboardDependencies._(context);

  static DashboardDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._services,
    ..._blocs,
  ];

  late final List<Provider> _services = [
    Provider<DashboardService>(
      create: (context) => DashboardService(
        context.read(),
      ),
    ),
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<DashboardBlocType>(
      create: (context) => DashboardBloc(
        context.read(),
        context.read(),
      ),
    ),
  ];
}
