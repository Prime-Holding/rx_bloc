{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/validators/login_validator_service.dart';
import '../blocs/onboarding_bloc.dart';
import '../views/onboarding_page.dart';

class OnboardingPageWithDependencies extends StatelessWidget {
  const OnboardingPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: const OnboardingPage(),
      );

  List<Provider> get _dataSources => [];

  List<Provider> get _repositories => [];

  List<Provider> get _services => [
        Provider<LoginValidatorService>(
          create: (context) => const LoginValidatorService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingBlocType>(
          create: (context) => OnboardingBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
