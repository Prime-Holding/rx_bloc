{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../../../base/extensions/error_model_field_translations.dart';
import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/email_change_bloc.dart';

class EmailChangePage extends StatelessWidget {
  const EmailChangePage({super.key});

  @override
  Widget build(BuildContext context) => RxForceUnfocuser(
        child: RxUnfocuser(
          child: Scaffold(
            appBar: customAppBar(context),
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.designSystem.spacing.xs1,
                horizontal: context.designSystem.spacing.xxxxl,
              ),
              child: Center(
                child: SingleChildScrollView(
                keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Icon(
                            context.designSystem.icons.email,
                            size: context.designSystem.spacing.xxxxl3,
                          ),
                          SizedBox(height: context.designSystem.spacing.s),
                          Text(
                            context.l10n.featureOnboarding.changeEmailTitle,
                            textAlign: TextAlign.center,
                            style: context.designSystem.typography.h1Med32,
                          ),
                          SizedBox(height: context.designSystem.spacing.xs),
                          Text(
                            context
                                .l10n.featureOnboarding.changeEmailDescription,
                            textAlign: TextAlign.center,
                            style: context.designSystem.typography.h2Reg16,
                          ),
                          SizedBox(height: context.designSystem.spacing.l),
                        ],
                      ),
                      RxTextFormFieldBuilder<EmailChangeBlocType>(
                        state: (bloc) => bloc.states.email.translate(context),
                        showErrorState: (bloc) => bloc.states.showFieldErrors,
                        onChanged: (bloc, value) => bloc.events.setEmail(value),
                        builder: (fieldState) => TextFormField(
                          autofocus: true,
                          controller: fieldState.controller,
                          textInputAction: TextInputAction.next,
                          decoration: fieldState.decoration.copyWith(
                            hintText:
                                context.l10n.featureOnboarding.changeEmailHint,
                          ),
                        ),
                      ),
                      SizedBox(height: context.designSystem.spacing.l),
                      RxBlocBuilder<EmailChangeBlocType, bool>(
                        state: (bloc) => bloc.states.isLoading,
                        builder: (context, loadingState, bloc) =>
                            GradientFillButton(
                          state: loadingState.isLoading
                              ? ButtonStateModel.loading
                              : ButtonStateModel.enabled,
                          onPressed: bloc.events.changeEmail,
                          text: context.l10n.featureOnboarding.changeEmail,
                        ),
                      ),
                      RxBlocListener<EmailChangeBlocType, ErrorModel>(
                        state: (bloc) => bloc.states.errors,
                        listener: (context, error) {
                          showErrorBlurredBottomSheet(
                            context: context,
                            error: error.translate(context),
                            configuration: const ModalConfiguration(
                              showCloseButton: true,
                              isDismissible: false,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
