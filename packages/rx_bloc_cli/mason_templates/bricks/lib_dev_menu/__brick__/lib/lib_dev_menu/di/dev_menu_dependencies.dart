import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/dev_menu_bloc.dart';
import '../data_source/dev_menu_data_source.dart';
import '../repository/dev_menu_repository.dart';
import '../service/dev_menu_service.dart';

class DevMenuDependencies {
  DevMenuDependencies._(this.context);

  factory DevMenuDependencies.from(BuildContext context) =>
      DevMenuDependencies._(context);

  final BuildContext context;
  late List<SingleChildWidget> providers = [
    ..._dataSources,
    ..._repositories,
    ..._services,
    ..._blocs,
  ];

  late final List<Provider> _dataSources = [
    Provider<DevMenuDataSource>(create: (context) => DevMenuDataSource())
  ];
  late final List<Provider> _repositories = [
    Provider<DevMenuRepository>(
        create: (context) => DevMenuRepository(
              context.read(),
              context.read(),
            ))
  ];
  late final List<Provider> _services = [
    Provider<DevMenuService>(
        create: (context) => DevMenuService(context.read()))
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<DevMenuBlocType>(
      create: (context) => DevMenuBloc(
        context.read(),
      ),
    ),
  ];
}
