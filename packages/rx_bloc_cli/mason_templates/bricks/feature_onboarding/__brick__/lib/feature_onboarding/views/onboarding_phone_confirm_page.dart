import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../../base/models/user_model.dart';
import '../../feature_otp/views/otp_page.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

/// Onboarding page where the user can confirm their phone number by entering a sms code.
class OnboardingPhoneConfirmPage extends StatelessWidget {
  const OnboardingPhoneConfirmPage({super.key});

  @override
  Widget build(BuildContext context) => OtpPage(
        appBar: AppBar(),
        otpService: context.read<SmsCodeService>(),
        contentAlignment: MainAxisAlignment.spaceAround,
        header: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            context.l10n.featureOnboarding.phoneNumberConfirmationHeader,
            style: context.designSystem.typography.h1Reg20,
            textAlign: TextAlign.center,
          ),
        ),
        onResult: (context, result) {
          final updatedUser = result as UserModel?;
          if (updatedUser != null && updatedUser.confirmedCredentials.phone) {
            context.read<RouterBlocType>().events.push(const DashboardRoute());
          }
        },
      );
}
