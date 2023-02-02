{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../blocs/enter_message_bloc.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.designSystem.spacing.xxxxl300,
          child: Column(
            children: [
              RxTextFormFieldBuilder<EnterMessageBlocType>(
                state: (bloc) => bloc.states.message,
                showErrorState: (_) => const Stream.empty(),
                builder: (fieldState) => SizedBox(
                  width: context.designSystem.spacing.xxxxl300,
                  child: TextFormField(
                    controller: fieldState.controller,
                    decoration: fieldState.decoration.copyWith(
                      labelText: context
                          .l10n.featureEnterMessage.fieldMessageLabel,
                    ),
                  ),
                ),
                onChanged: (bloc, value) => bloc.events.setMessage(value),
              ),
              SizedBox(height: context.designSystem.spacing.xs1),
              RxBlocBuilder<EnterMessageBlocType, String>(
                state: (bloc) => bloc.states.message,
                builder: (context, snapshot, bloc) => PrimaryButton(
                  onPressed: () => Navigator.of(context).pop(snapshot.data),
                  child: Text(context.l10n.confirm),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
