{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../blocs/password_reset_bloc.dart';

class PasswordResetConfirmedPage extends StatelessWidget {
  const PasswordResetConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.designSystem.spacing.l,
              0,
              context.designSystem.spacing.l,
              context.designSystem.spacing.m,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          context.designSystem.icons.success,
                          size: context.designSystem.spacing.xxxxl3,
                        ),
                        SizedBox(height: context.designSystem.spacing.l),
                        Text(
                          context.l10n.featurePasswordReset.passwordReset,
                          style: context.designSystem.typography.h1Med32,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.designSystem.spacing.xs),
                        Text(
                          context.l10n.featurePasswordReset.resetSuccess,
                          textAlign: TextAlign.center,
                          style: context.designSystem.typography.h2Reg16,
                        ),
                      ],
                    ),
                  ),
                ),
                GradientFillButton(
                  areIconsClose: true,
                  text: context.l10n.continueText,
                  onPressed: () => context
                        .read<PasswordResetBlocType>()
                        .events
                        .goToLogin(),
                ),
              ],
            ),
          ),
        ),
      );
}
