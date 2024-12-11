import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../repositories/user_repository.dart';
import '../services/onboarding_phone_sms_code_service.dart';
import '../services/user_service.dart';
import '../views/onboarding_phone_confirm_page.dart';

class OnboardingPhoneConfirmPageWithDependencies extends StatelessWidget {
  const OnboardingPhoneConfirmPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._repositories,
          ..._services,
        ],
        child: Builder(
          builder: (context) => const OnboardingPhoneConfirmPage(),
        ),
      );

  List<Provider> get _repositories => [
        Provider<UserRepository>(
          create: (context) => UserRepository(context.read()),
        ),
      ];

  List<Provider> get _services => [
        Provider<UserService>(
          create: (context) => UserService(
            context.read(),
            context.read(),
          ),
        ),
        Provider<SmsCodeService>(
          create: (context) => OnboardingPhoneSmsCodeService(
            context.read(),
          ),
        ),
      ];
}
