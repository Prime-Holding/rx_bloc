{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../blocs/enter_message_bloc.dart';
import '../services/enter_message_field_service.dart';

class EnterMessagePage extends StatelessWidget {
  const EnterMessagePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.pageWithResult,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.designSystem.spacing.xl,
                horizontal: context.designSystem.spacing.xl0,
              ),
              child: Container(
                padding: EdgeInsets.all(
                  context.designSystem.spacing.xs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.designSystem.colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      context.designSystem.spacing.xs,
                    ),
                  ),
                ),
                child: Text(
                  context.l10n.featureEnterMessage.pageDescription,
                  style: context.designSystem.typography.h3Med14,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: context.designSystem.spacing.xxxxl300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RxBlocBuilder<EnterMessageBlocType, String?>(
                      state: (bloc) => bloc.states.message,
                      builder: (context, message, bloc) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.designSystem.spacing.l,
                        ),
                        child: TextFieldDialog<String>(
                          translateError: (error) =>
                              ErrorModelFieldL10n.translateError<String>(
                                  error, context),
                          label: context
                              .l10n.featureEnterMessage.fieldMessageLabel,
                          value: message.data,
                          emptyLabel:
                              context.l10n.featureEnterMessage.fieldHintMessage,
                          validator: context.read<EnterMessageFieldService>(),
                          header:
                              context.l10n.featureEnterMessage.fieldHintMessage,
                          onChanged: (value) => bloc.events.setMessage(value),
                          modalConfiguration: const TextFieldModalConfiguration(
                            safeAreaBottom: false,
                          ),
                          fillButtonText:
                              context.l10n.featureEnterMessage.fillButtonText,
                        ),
                      ),
                    ),
                    SizedBox(height: context.designSystem.spacing.xs1),
                    RxBlocBuilder<EnterMessageBlocType, String?>(
                      state: (bloc) => bloc.states.message,
                      builder: (context, message, bloc) => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: GradientFillButton(
                          text: context.l10n.submit,
                          onPressed: message.data != null
                              ? () => Navigator.of(context).pop(message.data)
                              : null,
                          state: message.data != null
                              ? ButtonStateModel.enabled
                              : ButtonStateModel.disabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
