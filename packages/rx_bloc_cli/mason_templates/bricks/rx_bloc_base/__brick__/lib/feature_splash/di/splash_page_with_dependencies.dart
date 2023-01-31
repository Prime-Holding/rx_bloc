{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/splash_bloc.dart';
import '../services/splash_service.dart';
import '../views/splash_page.dart';

class SplashPageWithDependencies extends StatelessWidget {
  const SplashPageWithDependencies({super.key});

  List<Provider> get _services => [
    Provider<SplashService>(
      create: (context) => SplashService(
        context.read(),
      ),
    )
  ];

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<SplashBlocType>(
      create: (context) => SplashBloc(
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
    child: const SplashPage(),
  );
}
