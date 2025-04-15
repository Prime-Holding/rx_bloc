import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../blocs/onboarding_phone_confirm_bloc.dart';
import '../services/onboarding_phone_sms_code_service.dart';
import '../views/onboarding_phone_confirm_page.dart';

class OnboardingPhoneConfirmPageWithDependencies extends StatelessWidget {
  const OnboardingPhoneConfirmPageWithDependencies({
    required this.isOnboarding,
    super.key,
  });

  /// Indicates if the user is onboarding
  final bool isOnboarding;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: Builder(
          builder: (context) => const OnboardingPhoneConfirmPage(),
        ),
      );

  List<Provider> get _services => [
        Provider<SmsCodeService>(
          create: (context) => OnboardingPhoneSmsCodeService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingPhoneConfirmBlocType>(
          create: (context) => OnboardingPhoneConfirmBloc(
            isOnboarding,
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
