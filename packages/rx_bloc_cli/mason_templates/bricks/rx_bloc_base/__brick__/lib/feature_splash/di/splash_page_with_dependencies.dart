{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../lib_router/router.dart';
import '../blocs/splash_bloc.dart';
import '../views/splash_page.dart';

class SplashPageWithDependencies extends StatelessWidget {
const SplashPageWithDependencies({super.key});

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SplashBlocType>(
          create: (context) => SplashBloc(
            context.read<AppRouter>().router,{{#enable_feature_deeplinks}}
            context.read(),{{/enable_feature_deeplinks}}{{#has_authentication}}
            context.read(),{{/has_authentication}}
            context.read(),{{#enable_feature_onboarding}}
            context.read(),{{/enable_feature_onboarding}}
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
