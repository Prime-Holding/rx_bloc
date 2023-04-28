import 'package:alice/alice.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/dev_menu_bloc.dart';

class DevMenuDependencies {
  DevMenuDependencies._(this.context);

  factory DevMenuDependencies.from(BuildContext context) =>
      DevMenuDependencies._(context);

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._blocs,
    ..._packages,
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<DevMenuBlocType>(
      create: (context) => DevMenuBloc(),
    ),
  ];

  late final List<SingleChildWidget> _packages = [
    Provider<Alice>(
      create: (context) => Alice(
        showNotification: true,
        showInspectorOnShake: false,
        darkTheme: false,
        maxCallsCount: 1000,
      ),
    )
  ];
}
