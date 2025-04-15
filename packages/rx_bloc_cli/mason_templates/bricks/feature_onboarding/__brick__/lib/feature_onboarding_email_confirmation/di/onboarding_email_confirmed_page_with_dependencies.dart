{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/onboarding_email_confirmed_bloc.dart';
import '../views/onboarding_email_confirmed_page.dart';

class OnboardingEmailConfirmedPageWithDependencies extends StatelessWidget {
  const OnboardingEmailConfirmedPageWithDependencies({
    required String verifyEmailToken,
    required bool isOnboarding,
    super.key,
  })  : _verifyEmailToken = verifyEmailToken,
        _isOnboarding = isOnboarding;

  final String _verifyEmailToken;
  final bool _isOnboarding;

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
            _isOnboarding,
            context.read(),
            context.read(),
          ),
        ),
      ];
}
