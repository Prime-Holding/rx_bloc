import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/dashboard_bloc.dart';
import '../services/dashboard_service.dart';
import '../views/dashboard_page.dart';

/// A widget which provides the [DashboardPage] with the necessary dependencies
/// injected in the widget tree (such as services and blocs)
class DashboardPageWithDependencies extends StatelessWidget {
  const DashboardPageWithDependencies({super.key});

  List<Provider> get _services => [
        Provider<DashboardService>(
          create: (context) => DashboardService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<DashboardBlocType>(
          create: (context) => DashboardBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: DashboardPage(),
      );
}
