{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/splash_bloc.dart';
import '../views/splash_page.dart';

class SplashPageWithDependencies extends StatelessWidget {
  const SplashPageWithDependencies({
    this.redirectToLocation,
    Key? key,
  }) : super(key: key);

  final String? redirectToLocation;

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SplashBlocType>(
          create: (context) => SplashBloc(
            context.read(),
            context.read(),{{#has_authentication}}
            context.read(),{{/has_authentication}}
            redirectLocation: redirectToLocation,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const SplashPage(),
      );
}
