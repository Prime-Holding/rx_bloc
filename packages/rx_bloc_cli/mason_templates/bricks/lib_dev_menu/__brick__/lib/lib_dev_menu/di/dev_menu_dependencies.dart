import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/dev_menu_bloc.dart';
import '../data_source/dev_menu_data_source.dart';
import '../repository/dev_menu_repository.dart';
import '../service/dev_menu_service.dart';

class DevMenuDependencies {
  DevMenuDependencies();

  factory DevMenuDependencies.from(BuildContext context) =>
      DevMenuDependencies();

  late List<SingleChildWidget> providers = [
    ..._dataSources,
    ..._packages,
    ..._repositories,
    ..._services,
    ..._blocs,
  ];

  List<Provider> get _packages => [
        Provider<Alice>(
          create: (context) => Alice(
            configuration: AliceConfiguration(
              showNotification: true,
              showInspectorOnShake: false,
              storage: AliceMemoryStorage(maxCallsCount: 1000),
            ),
          ),
        )
      ];

  List<Provider> get _dataSources =>
      [Provider<DevMenuDataSource>(create: (context) => DevMenuDataSource())];
  List<Provider> get _repositories => [
        Provider<DevMenuRepository>(
            create: (context) => DevMenuRepository(
                  context.read(),
                  context.read(),
                ))
      ];
  List<Provider> get _services => [
        Provider<DevMenuService>(
            create: (context) => DevMenuService(context.read()))
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<DevMenuBlocType>(
          create: (context) => DevMenuBloc(
            context.read(),
          ),
        ),
      ];
}
