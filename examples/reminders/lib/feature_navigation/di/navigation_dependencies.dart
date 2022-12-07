import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/navigation_bloc.dart';

class NavigationDependencies {
  NavigationDependencies._(this.context);

  factory NavigationDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = NavigationDependencies._(context);

  static NavigationDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._blocs,
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<NavigationBlocType>(
      create: (context) => NavigationBloc(),
    ),
  ];
}
