{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../../../base/extensions/error_model_field_translations.dart';
import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/email_change_bloc.dart';

class EmailChangePage extends StatefulWidget {
  const EmailChangePage({super.key});

  @override
  State<EmailChangePage> createState() => _EmailChangePageState();
}

class _EmailChangePageState extends State<EmailChangePage> {
  final _emailFocusNode = FocusNode(debugLabel: 'emailFocus');

  @override
  void initState() {
    super.initState();
    _emailFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
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
            _buildEmailForm(context),
            SizedBox(height: context.designSystem.spacing.l),
            RxBlocBuilder<EmailChangeBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: _buildRegisterButton,
            ),
          ],
        ),
      );

  Widget _buildEmailForm(BuildContext context) =>
      RxTextFormFieldBuilder<EmailChangeBlocType>(
        state: (bloc) => bloc.states.email.translate(context),
        showErrorState: (bloc) => bloc.states.showFieldErrors,
        onChanged: (bloc, value) => bloc.events.setEmail(value),
        builder: (fieldState) => _buildEmailField(
          fieldState,
          context,
        ),
      );

  TextFormField _buildEmailField(
    RxTextFormFieldBuilderState<EmailChangeBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        controller: fieldState.controller,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocusNode,
        decoration: fieldState.decoration.copyWith(
          labelText: context.l10n.field.email,
        ),
      );

  GradientFillButton _buildRegisterButton(
    BuildContext context,
    AsyncSnapshot<bool> loadingState,
    EmailChangeBlocType bloc,
  ) =>
      GradientFillButton(
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        onPressed: bloc.events.changeEmail,
        text: context.l10n.featureOnboarding.changeEmail,
      );
}
