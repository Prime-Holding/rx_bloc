{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/onboarding_email_confirmed_bloc.dart';
import '../views/onboarding_email_confirmed_page.dart';

class OnboardingEmailConfirmedPageWithDependencies extends StatelessWidget {
  const OnboardingEmailConfirmedPageWithDependencies({
    required String verifyEmailToken,
    super.key,
  }) : _verifyEmailToken = verifyEmailToken;

  final String _verifyEmailToken;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const OnboardingEmailConfirmedPage(),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingEmailConfirmedBlocType>(
          create: (context) => OnboardingEmailConfirmedBloc(
            _verifyEmailToken,
            context.read(),
            context.read(),
          ),
        ),
      ];
}
