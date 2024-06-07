import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/stats_bloc.dart';
import '../services/stats_service.dart';
import '../views/statistics_page.dart';

class StatsPageWithDependencies extends StatelessWidget {
  const StatsPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const StatsPage(),
      );

  List<Provider> get _services => [
        Provider<StatsService>(
          create: (context) => StatsService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<StatsBlocType>(
          create: (context) => StatsBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}
