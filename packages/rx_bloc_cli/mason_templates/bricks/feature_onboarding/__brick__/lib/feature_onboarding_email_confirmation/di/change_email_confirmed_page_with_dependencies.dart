{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/email_change_service.dart';
import '../../base/common_services/onboarding_service.dart';
import '../blocs/onboarding_email_confirmed_bloc.dart';
import '../views/onboarding_email_confirmed_page.dart';

class ChangeEmailConfirmedPageWithDependencies extends StatelessWidget {
  const ChangeEmailConfirmedPageWithDependencies({
    required String verifyEmailToken,
    required this.isOnboarding,
    super.key,
  }) : _verifyEmailToken = verifyEmailToken;

  final String _verifyEmailToken;
  final bool isOnboarding;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const OnboardingEmailConfirmedPage(),
      );

  List<Provider> get _services => [
        Provider<OnboardingService>(
          create: (context) => EmailChangeService(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingEmailConfirmedBlocType>(
          create: (context) => OnboardingEmailConfirmedBloc(
            _verifyEmailToken,
            isOnboarding,
            context.read(),
            context.read(),
          ),
        ),
      ];
}
