import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/login_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) => RxBlocBuilder<LoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, bloc) => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading.isLoading ? null : bloc.events.goToRegistration,
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: context.l10n.featureLogin.dontHaveAccount,
                style: context.designSystem.typography.h2Reg16
                    .copyWith(color: context.designSystem.colors.dividerColor),
                children: [
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: context.l10n.featureLogin.signUpLabel,
                    style: context.designSystem.typography.h1Bold16,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
