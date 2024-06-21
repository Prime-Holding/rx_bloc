import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/statistics_bloc.dart';
import '../services/statistics_service.dart';
import '../views/statistics_page.dart';

class StatisticsPageWithDependencies extends StatelessWidget {
  const StatisticsPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const StatsPage(),
      );

  List<Provider> get _services => [
        Provider<StatisticsService>(
          create: (context) => StatisticsService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<StatisticsBlocType>(
          create: (context) => StatisticsBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}
