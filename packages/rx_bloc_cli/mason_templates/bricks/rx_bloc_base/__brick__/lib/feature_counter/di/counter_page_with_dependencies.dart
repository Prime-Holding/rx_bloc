{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/counter_bloc.dart';
import '../services/counter_service.dart';
import '../views/counter_page.dart';

class CounterPageWithDependencies extends StatelessWidget {
  const CounterPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const CounterPage(),
      );

  List<Provider> get _services => [
        Provider<CounterService>(
          create: (context) => CounterService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(
            context.read(),
          ),
        ),
      ];
}
